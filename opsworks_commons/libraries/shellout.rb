module OpsWorks
  module ShellOut
    extend self

    def shellout(command)
      cmd = Mixlib::ShellOut.new(command)
      cmd.run_command
      cmd.error!
      [cmd.stderr, cmd.stdout].join("\n")
    end
  end
end
