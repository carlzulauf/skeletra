class Skeletra
  def self.config
    yield Config.instance if block_given?
    Config.instance
  end

  def self.root
    config.root
  end

  def self.logger
    config.logger
  end

  def self.work
    WorkQueue.instance
  end

  def self.schedule
    Schedule.instance
  end

  def self.java?
    RUBY_PLATFORM == "java"
  end
end

require 'skeletra/config'
require 'skeletra/work_queue'
require 'skeletra/work_helpers'
require 'skeletra/schedule'
require 'skeletra/server'
