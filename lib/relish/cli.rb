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

require 'optparse'
require 'relish/exception'

module Relish
  class CLI
    
    attr_accessor :config
    
    def initialize(argv=ARGV)
      @config = {
        :nanite_host => Relish::Config[:nanite_host],
        :nanite_user => Relish::Config[:nanite_user],
        :nanite_pass => Relish::Config[:nanite_pass],
        :nanite_vhost => Relish::Config[:nanite_vhost]
      }
      load_args(argv)
    end
    
    def default_opts(opts, argv) 
      opts.banner = "Usage: #{$0} (options)"
      opts.on("-c CONFIG", "--config CONFIG", "The Relish Config file to use") do |c|
        @config[:config_file] = c
      end
      opts.on("-l LEVEL", "--loglevel LEVEL", "Set the log level (debug, info, warn, error, fatal)") do |l|
        @config[:log_level] = l
      end
      opts.on("-L LOGLOCATION", "--logfile LOGLOCATION", "Set the log file location, defaults to STDOUT - recommended for daemonizing") do |lf|
        @config[:log_location] = lf
      end
      opts.on("--nanite-host HOST", "The nanite exchange host") do |n|
        @config[:nanite_host] = n
      end
      opts.on("--nanite-user USER", "The nanite user name") do |n|
        @config[:nanite_user] = n
      end
      opts.on("--nanite-pass PASS", "The nanite password") do |p|
        @config[:nanite_pass] = p
      end
      opts.on("--nanite-vhost VHOST", "The nanite vhost") do |v|
        @config[:nanite_vhost] = v
      end
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit 0
      end
      opts.parse!(argv)
    end
    
    def load_args(argv)
      opts = OptionParser.new do |opts|          
        default_opts(opts, argv)
      end
    end
  end
end