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
#

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require 'relish/cli/build'

describe Relish::CLI::Build do
  before(:each) do
    @cli = Relish::CLI::Build.new([])
  end
  
  describe "initialize" do
    it "should return a Relish::CLI::Build" do
      @cli.should be_a_kind_of(Relish::CLI::Build)
    end
  end

  describe "load_args" do      
    it_should_check_cli_arguments(
      [ '-a', 'application', :application ],
      [ '--application', 'application', :application ],
      [ '-b', 'branch', :branch ],
      [ '--branch', 'branch', :branch ],
      [ '-C', 'make-command', :make_command ],
      [ '--make-command', 'make-command', :make_command ],
      [ '-r', 'repository', :repository ],
      [ '--repository', 'repository', :repository ],
      [ '-t', 'make-tool', :make_tool ],
      [ '--make-tool', 'make-tool', :make_tool ]
    )

    # This is testing that we cascade to Relish::CLI properly for args
    it_should_check_cli_arguments(
      [ '-c', '--config', :config_file ]
    )
  end
  
  describe "run" do
    before(:each) do
      EM.stub!(:run).and_return(true)
      gw = mock("Net::SSH::Gateway", :null_object => true)
      Net::SSH::Gateway.stub!(:new).and_return(gw)
      @cli.config[:application] = 'foo'
      @cli.config[:repository] = 'woot'
      @cli.config[:server] = 'localhost'
    end
    
    it "should raise an ArgumentError if an application is not configured" do
      @cli.config[:application] = nil
      lambda { @cli.run }.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if a repository is not configured" do
      @cli.config[:repository] = nil
      lambda { @cli.run }.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if a server is not configured" do
      @cli.config[:server] = nil
      lambda { @cli.run }.should raise_error(ArgumentError)
    end
    
    it "should return output and exit status" do
      output, exit_status = @cli.run
      output.should eql("")
      exit_status.should == 0
    end
  end
  
end