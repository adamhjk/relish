Given /^a relish server of '(.+)'$/ do |server|
  @options << [ '-s', server ]
end

Given /^a source control repository of '(.+)'$/ do |repo|
  @options << ['-r', repo ]
end

Given /^a branch of '(.+)'$/ do |branch|
  @options << [ '-b', branch ]
end

Given /^an application name of '(.+)'$/ do |appname|
  @options << [ '-a', appname ]
end

Given /^using '(.+)' as the make tool$/ do |make_tool|
  @options << [ '-t', make_tool ]
end

Given /^using '(.+)' as the make command$/ do |make_command|
  @options << [ '-c', make_command ]
end


