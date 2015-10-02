#
# original code from https://github.com/opscode/chef/blob/master/lib/chef/provider/deploy.rb
#
# Author:: Daniel DeLeo (<dan@kallistec.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# This patch will only show environment variables, when explicitly wanted. To do this
# the environment variable SHOW_ENVIRONMENT_VARIABLES must exist

class Chef
  class Provider
    class Deploy

      def migrate
        run_symlinks_before_migrate

        if @new_resource.migrate
          enforce_ownership

          environment = @new_resource.environment
          env_info = environment && environment.map do |key_and_val|
            "#{key_and_val.first}='#{key_and_val.last}'"
          end.join(" ")

          converge_by("execute migration command #{@new_resource.migration_command}") do
            if environment && environment.key?("SHOW_ENVIRONMENT_VARIABLES")
              Chef::Log.info "#{@new_resource} migrating #{@new_resource.user} with environment #{env_info}"
            else
              Chef::Log.info "#{@new_resource} migrating #{@new_resource.user}"
            end
            run_command(run_options(:command => @new_resource.migration_command, :cwd=>release_path, :log_level => :info))
          end
        end
      end

    end
  end
end
