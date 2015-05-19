module OpsWorks
  module ShellOut
    extend self

    def shellout(command, options = {})
      options = {:timeout => 1200}.merge(options)
      cmd = Mixlib::ShellOut.new(command, options)
      cmd.run_command
      cmd.error!
      [cmd.stderr, cmd.stdout].join("\n")
    end
  end
end
