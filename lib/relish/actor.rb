require 'relish/builder'
require 'nanite/actor'

module Relish
  class Actor < ::Nanite::Actor
    expose :build

    def build(payload)
      puts "I am rocking the builder"
      builder = Relish::Builder.new(payload)
      begin
        builder.check_build
      rescue IOError => e
        puts "Opps, I had a failure!\n#{pp e}"
      end
      
      {
        :platform => builder.platform,
        :version => builder.version,
        :output => builder.output,
        :exit_status => builder.exit_status,
        :fqdn => builder.fqdn
      }
    end

  end
end