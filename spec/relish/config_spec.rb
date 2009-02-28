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

describe Relish::Config do
  
  it "should raise an ArgumentError with an explanation if you try and set a non-existent variable" do
    lambda { 
      Relish::Config.whattheheck('something') 
    }.should raise_error(ArgumentError)
  end
  
  it "should allow you to reference a value by index" do
    Relish::Config[:application].should be(nil)
  end
  
  it "should allow you to set a value by index" do
    Relish::Config[:application] = "one"
    Relish::Config[:application].should == "one"
  end
  
  it "should allow you to set config values with a block" do
    Relish::Config.configure do |c|
      c[:application] = "monkey_rabbit"
      c[:otherthing] = "boo"
    end
    Relish::Config.application.should == "monkey_rabbit"
    Relish::Config.otherthing.should == "boo"
  end
  
  it "should raise an ArgumentError if you access a config option that does not exist" do
    lambda { Relish::Config[:snob_hobbery] }.should raise_error(ArgumentError)
  end
  
  it "should return true or false with has_key?" do
    Relish::Config.has_key?(:monkey).should eql(false)
    Relish::Config[:monkey] = "gotcha"
    Relish::Config.has_key?(:monkey).should eql(true)
  end
  
end