define :fallback, :resource => nil, :fallback_options => [] do
  old_action = params[:resource].action
  params[:resource].action :nothing

  ruby_block "Fallback for #{params[:resource].to_s}" do
    block do
      begin
        params[:resource].run_action old_action
      rescue => e
        Chef::Log.warn "#{params[:resource]} failed: #{e.class}: #{e}"
        if params[:fallback_options].empty?
          raise
        else
          params[:fallback_options].shift.each {|k, v| params[:resource].send(k, v)}
          retry
        end
      end
    end
  end
end
