require "./config/environment"
require "sinatra/asset_pipeline/task"
require "rspec/core/rake_task"

Sinatra::AssetPipeline::Task.define! Skeletra::Server

RSpec::Core::RakeTask.new(:spec)
task :default => [:spec]

desc "Pry console with env loaded"
task :pry do |app|
  binding.pry
end
