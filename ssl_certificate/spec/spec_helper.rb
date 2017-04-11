# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'libraries'))

require 'chefspec'
require 'chefspec/berkshelf'
require 'should_not/rspec'

# require 'support/coverage'

RSpec.configure do |config|
  # Prohibit using the should syntax
  config.expect_with :rspec do |spec|
    spec.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  # config.order = 'random'
  # Library tests first (they are capitalized) to not interfere with coverage
  config.register_ordering(:global) do |list|
    list.sort_by(&:description)
  end

  # ChefSpec configuration
  config.log_level = :fatal
  config.color = true
  config.formatter = :documentation
  config.tty = true
  config.platform = 'ubuntu'
  config.version = '12.04'
end

at_exit { ChefSpec::Coverage.report! }
