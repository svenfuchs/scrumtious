TEST_ROOT = File.expand_path(File.dirname(__FILE__))
ENV["RAILS_ENV"] = "test"

require "#{TEST_ROOT}/../config/environment"
require 'test_help'
require 'active_support/test_case'
require 'active_resource/http_mock'

Dir["#{TEST_ROOT}/test_helpers/*.rb"].each{|path| require path }
require "#{RAILS_ROOT}/spec/spec_helpers/http_mock_helper"

class Test::Unit::TestCase
end

require 'application'
ApplicationController.class_eval do
  def http_auth
    @@http_auth ||= YAML.load_file("#{TEST_ROOT}/http_auth.yml")
  end
end
    
