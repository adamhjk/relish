$: << File.join(File.dirname(__FILE__), "..")

require 'relish'

register(Relish::Actor.new, 'relish')