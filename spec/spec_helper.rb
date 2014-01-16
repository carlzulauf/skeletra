require File.join(File.dirname(__FILE__), "..", "config", "environment")

require 'rack/test'

module Skeletra::ServerTestMixin
  include Rack::Test::Methods
  def app
    Skeletra::Server
  end
end

RSpec.configure { |c| c.include Skeletra::ServerTestMixin }
