require File.dirname(__FILE__) + '/spec_helper'

describe Relish do
  it "should have a major.minor.patch style version" do
    Relish::VERSION.should match(/^\d+\.\d+\.\d+$/)
  end
end