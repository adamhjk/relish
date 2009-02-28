$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'relish'

def it_should_check_cli_arguments(*load_args_list)
  load_args_list.each do |to_test|
    load_args = to_test[0..1]
    config_symbol = to_test[2]
    it "should set #{config_symbol} via #{to_test[0..1].join(" ")}" do
      @cli.load_args(to_test[0..1])
      @cli.config[to_test[2]].should == to_test[1]
    end
  end
end