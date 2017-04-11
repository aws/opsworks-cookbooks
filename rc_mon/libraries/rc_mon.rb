module RcMon
  class << self
    def get_bytes(s)
      s = s.to_s
      indx = [nil, 'k', 'm', 'g']
      power = indx.index(s.slice(-1, s.length).to_s.downcase).to_i * 10
      (2**power) * s.to_i
    end
  end

  module ProviderMethods

    def service_dir
      unless(@srv_dir)
        runit_resource = build_runit_resource
        @srv_dir = ::File.join(runit_resource.sv_dir, runit_resource.service_name)
      end
      @srv_dir
    end

    def control_dir
      unless(@ctrl_dir)
        @ctrl_dir = ::File.join(service_dir, 'control')
        directory @ctrl_dir do
          recursive true
        end
      end
      @ctrl_dir
    end

    def write_up_control(controls, do_action=:create)
      template ::File.join(control_dir, 'u') do
        source 'runit_control_up.erb'
        cookbook 'rc_mon'
        mode 0755
        action do_action
        variables(
          :controls => controls,
          :group => new_resource.group_name
        )
        notifies :restart, build_runit_resource, :delayed
      end
    end

    def command_prefix
      if(new_resource.control_user)
        user_args = [new_resource.control_user, new_resource.control_group].compact.join(':')
        "chpst -u #{user_args}" unless user_args.empty?
      end
    end

    def write_run_file(do_action = :create)
      if(new_resource.start_command)
        template ::File.join(service_dir, 'run') do
          source 'runit_script.erb'
          cookbook 'rc_mon'
          mode 0755
          action do_action
          variables(
            :command => new_resource.start_command,
            :command_prefix => command_prefix
          )
          notifies :restart, build_runit_resource, :delayed
        end
      end
    end

    def write_control_files(do_action = :create)
      {:stop_command => [:d, :x, :e]}.each do |attribute, files|
        [files].flatten.compact.each do |control_file|
          template ::File.join(control_dir, control_file.to_s) do
            source 'runit_script.erb'
            cookbook 'rc_mon'
            mode 0755
            action do_action
            variables(
              :command => new_resource.send(attribute),
              :command_prefix => command_prefix
            )
            notifies :restart, build_runit_resource, :delayed
          end
        end
      end
    end

    def build_runit_resource
      unless(@runit_resource)
        @runit_resource = Chef::Resource::RunitService.new(new_resource.name, new_resource.run_context)
        if(new_resource.runit_attributes)
          new_resource.runit_attributes.each do |k,v|
            @runit_resource.send(k, v)
          end
        end
        @runit_resource.action new_resource.action
        @runit_resource.subscribes(:restart,
          new_resource.run_context.resource_collection.lookup(
            'ruby_block[control_groups[write configs]]'
          ), :delayed
        )
        new_resource.run_context.resource_collection << @runit_resource
        unless(Mash.new(new_resource.runit_attributes).has_key?(:run_template_name))
          @runit_resource.run_template_name 'default'
          @runit_resource.options(:path => ::File.join(service_dir, 'run'))
          @runit_resource.cookbook 'rc_mon'
        end
        @runit_resource.default_logger true
      end
      @runit_resource
    end

    def configure_cgroups
      if(new_resource.memory_limit)
        mem_limit = RcMon.get_bytes(new_resource.memory_limit)
        memsw_limit = mem_limit + RcMon.get_bytes(new_resource.swap_limit)
      end
      control = []
      if(new_resource.cpu_shares || new_resource.memory_limit)
        control_groups_entry new_resource.group_name do
          if(new_resource.memory_limit)
            memory(
              'memory.limit_in_bytes' => mem_limit,
              'memory.memsw.limit_in_bytes' => memsw_limit
            )
            control << 'memory'
          end
          if(new_resource.cpu_shares)
            cpu 'cpu.shares' => new_resource.cpu_shares
            control << 'cpu'
          end
        end
      end
      control
    end

  end
end
