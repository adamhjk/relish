#
# Author:: Adam Jacob (<adam@opscode.com>)
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

require 'rubygems'
require 'nanite'
require 'relish/cli'

module Relish
  class CLI
    class Agent < Relish::CLI
          
      def load_args(argv)
        @config = {
          :root => File.expand_path(File.join(File.dirname(__FILE__), "..")),
          :host => Relish::Config[:nanite_host],
          :user => Relish::Config[:nanite_user],
          :pass => Relish::Config[:nanite_pass],
          :vhost => Relish::Config[:nanite_vhost]
        }
        super(argv)
      end
      
      def run
        EM.run do
          Nanite.start_agent(@config)
        end
      end
      
    end
  end
end
