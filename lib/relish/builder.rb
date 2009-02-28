require 'rubygems'
require 'ohai'

module Relish
  class Builder
    attr_reader :platform, :version, :output, :exit_status, :fqdn
    attr_accessor :for_platform, :for_version, :application, :repository, 
                  :branch, :make_tool, :make_command, :build_dir, :app_repo_dir
    
    def initialize(args={})      
      Ohai::Log.level(:error)
      @ohai = Ohai::System.new
      @ohai.require_plugin("os")
      @ohai.require_plugin("platform")
      @ohai.require_plugin("hostname")
      @platform = @ohai[:platform]
      @version = @ohai[:platform_version]
      @fqdn = @ohai[:fqdn]
      
      @for_platform = args[:for_platform]    || Relish::Config[:for_platform]    || @platform
      @for_version  = args[:for_version]     || Relish::Config[:for_version]     || @version
      @application  = args[:application]     || Relish::Config[:application]
      @repository   = args[:repository]      || Relish::Config[:repository]
      @branch       = args[:branch]          || Relish::Config[:branch]
      @make_tool    = args[:make_tool]       || Relish::Config[:make_tool]
      @make_command = args[:make_command]    || Relish::Config[:make_command]
      @build_dir    = args[:build_directory] || Relish::Config[:build_directory]
      
      unless @application
        raise ArgumentError, "Must have an application name"
      end
      
      @output = ""
      @exit_status = 0
      @app_repo_dir = File.join(@build_dir, @application)
    end
    
    def check_platform
      if (@platform == @for_platform) && (@version == @for_version)
        true
      else
        false
      end
    end
    
    def check_build
      check_platform
      run_command("mkdir -p #{@build_dir}")
      Dir.chdir(@build_dir)
      run_command("git clone #{@repository} #{@app_repo_dir}")
      Dir.chdir(@app_repo_dir)
      run_command("git checkout #{@branch}")
      run_command("#{@make_tool} #{@make_command}")
      Dir.chdir(@build_dir)
    end
    
    def cleanup
      run_command("rm -rf #{@app_repo_dir}")
    end
    
    def run_command(command)
      @output << "--- Running #{command} ---\n"
      IO.popen("sh -c '#{command}' 2>&1") do |i|
        @output << i.read
      end
      if $?.exitstatus != 0
        @output << "--- Command #{command} failed; RC #{$?.exitstatus} ---\n"
        @exit_status = $?.exitstatus
        puts @output
        raise IOError, "Command failed"
      end
    end
  
  end
end