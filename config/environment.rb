$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))

Bundler.require

require 'singleton'
require 'json'
require 'securerandom'
require "sinatra/base"
require "sinatra/jsonp"

# asset stuff
require "sass"
require "coffee_script"

# for development only
require "pry"

require "skeletra"

Skeletra.config do |config|
  config.root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
end

Skeletra::Server.configure do |c|
  c.views = Skeletra.root.join("views")
  c.public_folder = Skeletra.root.join("public")
  c.assets_precompile = %w(app.js app.css vendor.js vendor.css *.png *.jpg)
end
