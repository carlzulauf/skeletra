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
  rm_dirs = []
  files.each do |file|
    print "#{file} .. "
    contents = File.read(file)
    contents = contents.gsub(/Skeletra/, name)
    contents = contents.gsub(/skeletra/, lcase)
    path = file.gsub(/skeletra/, lcase)
    unless path == file
      dir = File.dirname(path)
      unless Dir.exist?(dir)
        Dir.mkdir(dir)
        rm_dirs << File.dirname(file)
      end
      File.delete(file)
    end
    File.write(path, contents)
    print "done\n"
  end
  rm_dirs.each do |d|
    Dir.rmdir d
    puts "Removed #{d}"
  end
end
