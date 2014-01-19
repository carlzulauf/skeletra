class Skeletra::Schedule
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @schedules = []
    @watcher = Thread.new{ watch }
  end

  def add(*args, &block)
    job = block_given? ? block : args.first
    add_entry Entry.new(job, args.extract_options!)
  end

  def add_entry(entry)
    sync do
      @schedules << entry
      @schedules.sort_by!(&:at)
    end
    tickle_watcher
  end

  def tickle_watcher
    @watcher.wakeup if @watcher.stop?
  end

  def sync
    @semaphore.synchronize{ yield }
  end

  def clear
    sync{ @schedules.clear }
  end

  def watch
    loop do
      Thread.stop if @schedules.empty?
      entries_due.each do |entry|
        log.debug "Adding scheduled job to work queue"
        entry.work!
        add_entry entry if entry.repeat?
      end
      next_job = @schedules.first
      sleep(next_job.at - Time.now) if next_job && next_job.future?
    end
  end

  def entries_due
    [].tap do |entries|
      sync do
        while @schedules.first && @schedules.first.due?
          entries << @schedules.shift
        end
      end
    end
  end

  def count
    @schedules.count
  end

  def log
    Skeletra.logger
  end

  class Entry < Struct.new(:at, :job, :repeat)
    def work!
      Skeletra.work.enqueue job
    end
  end

  class Entry
    attr_accessor :job, :at, :repeat

    def initialize(job, options = {})
      self.job = job
      seconds = options[:in] || options[:every]
      self.at = seconds ? Time.now + seconds : options[:at]
      self.repeat = options[:every]
    end

    def repeat?
      !! repeat
    end

    def due?
      Time.now > at
    end

    def future?
      ! due?
    end

    def work!
      Skeletra.work.enqueue job
      self.at = Time.now + repeat if repeat?
    end
  end
end
