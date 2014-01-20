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

task :rename do
  name = ENV["NAME"]
  lcase = name.underscore
  files = `git ls-files`.split("\n")
  files.each do |file|
    print "#{file} .. "
    contents = File.read(file)
    contents = contents.gsub(/Skeletra/, name)
    contents = contents.gsub(/skeletra/, lcase)
    File.write(file, contents)
    print "done\n"
  end
end
