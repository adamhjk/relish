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

require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require 'relish/cli'

describe Relish::CLI do
  before(:each) do
    @cli = Relish::CLI.new([])
  end
  
  describe "intialize" do
    it "should return a Relish::CLI" do
      @cli.should be_a_kind_of(Relish::CLI)
    end
  end
  
  describe "load_args" do    
    it_should_check_cli_arguments(
      [ '-c', 'whatsup', :config_file ],
      [ '--config', 'whatsup', :config_file ],
      [ '-l', 'debug', :log_level],
      [ '--loglevel', 'debug', :log_level ],
      [ '-L', 'thembones', :log_location ],
      [ '--logfile', 'thembones', :log_location ],
      [ '--nanite-host', 'foo', :nanite_host ],
      [ '--nanite-user', 'user', :nanite_user ],
      [ '--nanite-pass', 'pass', :nanite_pass ],
      [ '--nanite-vhost', 'vhost', :nanite_vhost ]
    )
  end
end