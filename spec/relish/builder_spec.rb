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

require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Relish::Builder do
  
  before(:each) do
    @builder = Relish::Builder.new(:application => 'relish')
  end
  
  describe "initialize" do
    it "should return a new Relish::Builder" do
      @builder.should be_a_kind_of(Relish::Builder)
    end
    
    it "should raise an exception if no application name is available" do
      lambda { Relish::Builder.new }.should raise_error(ArgumentError)
    end
  end
  
  describe "check_platform" do
    it "should return true if the current system is the platform and version for this build" do
      @builder.check_platform.should be(true)
    end
    
    it "should return false if the current system is not the correct platform" do
      @builder.for_platform = 'monkeypants'
      @builder.check_platform.should be(false)
    end

    it "should return false if the current system is not the correct version" do
      @builder.for_version = 'monkeypants'
      @builder.check_platform.should be(false)
    end
  end
  
  describe "check_build" do
    before(:each) do
      @build_directory = "monkey"
      @builder.build_dir = @build_directory
      @builder.repository = "git://github.com/opscode/monkey"
      @builder.stub!(:check_platform).and_return(true)
      @builder.stub!(:run_command).and_return(true)
      Dir.stub!(:chdir).and_return(true)
    end
    
    it "should check the platform for this build" do
      @builder.should_receive(:check_platform).and_return(true)
      @builder.check_build
    end
    
    it "should create the relish build directory" do
      @builder.should_receive(:run_command).with("mkdir -p #{@build_directory}")
      @builder.check_build
    end
    
    it "should change to the relish build directory" do
      Dir.should_receive(:chdir).with(@build_directory).twice
      @builder.check_build
    end
    
    it "should clone the git repository" do
      @builder.should_receive(:run_command).with("git clone #{@builder.repository} #{@builder.app_repo_dir}")
      @builder.check_build
    end
    
    it "should change to the application build directory" do
      Dir.should_receive(:chdir).with(@builder.app_repo_dir)
      @builder.check_build
    end
    
    it "should check out the branch" do
      @builder.should_receive(:run_command).with("git checkout #{@builder.branch}")
      @builder.check_build
    end
    
    it "should run the make command" do
      @builder.should_receive(:run_command).with("#{@builder.make_tool} #{@builder.make_command}")
      @builder.check_build
    end
  end
  
  describe "cleanup" do
    it "should remove the application repository directory" do
      @builder.should_receive(:run_command).with("rm -rf #{@builder.app_repo_dir}")
      @builder.cleanup
    end
  end

  describe "run_command" do
    before(:each) do
      @command = "echo bunnies"
    end
    
    it "should append the command output to our output" do
      @builder.run_command(@command)
      @builder.output.should == "--- Running #{@command} ---\nbunnies\n"
    end
    
    it "should raise an IOError if the command fails" do
      lambda { @builder.run_command("exit 1") }.should raise_error(IOError)
    end
    
    it "should append the command output and return code to our output on failure" do
      begin
        @builder.run_command("#{@command}; exit 1")
      rescue
      end
      @builder.output.should == "--- Running echo bunnies; exit 1 ---\nbunnies\n--- Command echo bunnies; exit 1 failed; RC 1 ---\n"
    end
  end

end