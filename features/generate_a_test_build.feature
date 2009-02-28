Feature: Generate a test build
  In order to ensure software is working correctly
  As a Developer
  I want to generate test builds on multiple platforms
    
  Scenario: Run a successful build task
    Given a relish server of 'localhost'
      And a source control repository of 'git://github.com/opscode/chef'
      And a branch of 'master'
      And an application name of 'chef'
      And using 'rake' as the make tool
      And using 'spec' as the make command
     When you run 'relish_build'
     Then it should exit '0'
      And the output should include 'Build Successful'
      
  Scenario: Run an unsuccessful build task
    Given a relish server of 'localhost'
      And a source control repository of 'git://github.com/opscode/chef'
      And a branch of 'master'
      And an application name of 'chef'
      And using 'rake' as the make tool
      And using 'failure' as the make command  
     When you run 'relish_build'
     Then it should exit '1'
      And the output should include 'Build Failed'
      