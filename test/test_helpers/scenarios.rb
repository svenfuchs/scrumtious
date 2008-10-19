module Scenario
  mattr_reader :scenarios
  @@scenarios = {}
  
  class << self
    def define(name, &block)
      scenarios[name] = block
    end
  end
  
  def scenario(*names)
    names.each do |name|
      if scenarios[name]
        instance_eval &scenarios[name] 
      else
        raise "scenario #{name.inspect} not defined"
      end
    end
  end
end

Test::Unit::TestCase.send :include, Scenario

Dir[File.expand_path(File.dirname(__FILE__)) + "/../scenarios/*.rb"].each do |path|
  require path
end

