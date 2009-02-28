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
require 'net/ssh/gateway'
require 'relish/cli'

module Relish
  class CLI
    class Build < Relish::CLI
          
      def load_args(argv)
        @config = {
          :application => Relish::Config[:application],
          :branch => Relish::Config[:branch],
          :make_command => Relish::Config[:make_command],
          :repository => Relish::Config[:repository],
          :make_tool => Relish::Config[:make_tool],
          :user => ENV['USER'],
          :nanite_host => Relish::Config[:nanite_host],
          :nanite_user => Relish::Config[:nanite_user],
          :nanite_pass => Relish::Config[:nanite_pass],
          :nanite_vhost => Relish::Config[:nanite_vhost]
        }
  
        opts = OptionParser.new do |opts|          
          opts.on("-a NAME", "--application NAME", "The name of the application to build") do |a|
            @config[:application] = a
          end
          opts.on("-b BRANCH", "--branch BRANCH", "The name of the branch to build") do |b|
            @config[:branch] = b
          end
          opts.on("-C COMMAND", "--make-command COMMAND", "The name of the command to call with the make tool") do |c|
            @config[:make_command] = c
          end
          opts.on("-r REPO", "--repository REPO", "The full path to the git repository to check out") do |r|
            @config[:repository] = r
          end  
          opts.on("-s SERVER", "--server SERVER", "The hostname or IP address of your relish server") do |s|
            @config[:server] = s
          end
          opts.on("-t TOOL", "--make-tool TOOL", "The name of the make tool to use (rake/make/ant)") do |t|
            @config[:make_tool] = t
          end
          opts.on("-u USER", "--user USER", "The username we use to ssh to the relish server") do |u|
            @config[:user] = u
          end
        end
        default_opts(opts, argv)
      end
      
      def run                
        unless @config[:application]
          raise ArgumentError, "You need to set the application name (-a)"
        end
        
        unless @config[:repository]
          raise ArgumentError, "You need to set the git repository (-r)"
        end 
        
        unless @config[:server]
          raise ArgumentError, "You need to set the relish server (-s)"
        end     
                
        output = ""
        exit_status = 0
        
        gateway = Net::SSH::Gateway.new(@config[:server], @config[:user])

        gateway.open('localhost', 5672) do |port|
          puts "I have my #{port}"
          EM.run do
            # start up a new mapper with a ping time of 15 seconds
            mapper = Nanite::Mapper.start(
              :host      => 'localhost', 
              :user      => @config[:nanite_user], 
              :pass      => @config[:nanite_pass], 
              :vhost     => @config[:nanite_vhost], 
              :port      => port,
              :log_level => 'info',
              :log_dir   => 'log'
            )
            puts "I have started my mapper"

            # have this run after 16 seconds so we can be pretty sure that the mapper
            # has already received pings from running nanites and registered them.
            EM.add_timer(16) do
              puts "I have run after 16 seconds"
              # call our /simple/echo nanite, and pass it a string to echo back
              mapper.request("/relish/build", { 
                :application  => @config[:application],
                :repository   => @config[:repository], 
                :branch       => @config[:branch],
                :make_tool    => @config[:make_tool],
                :make_command => @config[:make_command]
              }) do |res|
                res.each do |token, build_output|
                  puts "I have rocked some output"
                  output << "- Build for #{build_output[:platform]} version #{build_output[:version]} on #{build_output[:fqdn]}\n"
                  output << "#{build_output[:output]}\n"
                  if build_output[:exit_status] != 0
                    exit_status = build_output[:exit_status]
                  end
                end
                puts "I have quit the event loop"
                EM.stop_event_loop
              end
            end
          end
        end
        
        gateway.shutdown!
        puts "I have shut the gateway down"

        return output, exit_status
      end
          
    end
  end
end
