# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL. (www.onddo.com)
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

require 'spec_helper'
require 'chef/mixin/template'

# Emulates the Chef template render engine.
class TemplateRender
  def initialize(f)
    file(f)
  end

  def attributes_dir
    File.join(::File.dirname(__FILE__), '..', '..', 'attributes')
  end

  def template_dir
    File.join(::File.dirname(__FILE__), '..', '..', 'templates', 'default')
  end

  def file(arg)
    @path = ::File.join(template_dir, arg)
  end

  def node
    @node ||= begin
      n = Chef::Node.new
      n.name('node001')
      Dir.glob(::File.join(attributes_dir, '*.rb')) { |f| n.from_file(f) }
      n
    end
  end

  def render(variables = {})
    context = Chef::Mixin::Template::TemplateContext.new(variables)
    context[:node] = node
    context.render_template(@path)
  end
end
