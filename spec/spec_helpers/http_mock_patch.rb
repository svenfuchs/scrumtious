require 'active_resource/http_mock'

module ActiveResource
  class HttpMock
    class << self
      # monkeypatch so it doesn't reset responses when called
      def respond_to
        yield Responder.new(responses)
      end
    end
  end
end

if defined? Spec::Rails::Example::RailsExampleGroup
  class Spec::Rails::Example::RailsExampleGroup
    after :each do 
      ActiveResource::HttpMock.reset!
    end
  end
end

if defined? ActionController::IntegrationTest
  class ActionController::IntegrationTest
    teardown do 
      ActiveResource::HttpMock.reset!
    end
  end
end