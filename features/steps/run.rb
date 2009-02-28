###
# When
###
When /^you run '(.+)'$/ do |command|
  fq_command = File.join(File.dirname(__FILE__), "..", "..", "bin", command)
  total_command = "#{fq_command} #{@options.join(' ')}"
  IO.popen("sh -c '#{total_command}' 2>&1") do |i|
    @output << i.read
  end
  if $?.exitstatus != 0
    @status = $?
  end
end

###
# Then
###
Then /^it should exit '(.+)'$/ do |exit_code|
  begin
    @status.exitstatus.should eql(exit_code.to_i)
  rescue 
    puts "--- run stdout: #{@stdout}"
    puts @stdout
    puts "--- run stderr: #{@stderr}"
    raise
  end
end

Then /^the output should include '(.+)'$/ do |to_match|
  @output.should match(/#{to_match}/m)
end
