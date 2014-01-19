class Skeletra::Schedule
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @schedules = []
    @watcher = Thread.new{ watch }
  end

  def add(*args, &block)
    options = args.extract_options!
    at = parse_time(options)
    job = block_given? ? block : args.first
    add_entry Entry.new(at, job, options[:every])
  end

  def parse_time(options)
    seconds = (options[:in] || options[:every])
    if seconds
      Time.now + seconds
    elsif options[:at]
      options[:at]
    end
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
      now = Time.now
      entries_due(now).each do |entry|
        log.debug "Adding scheduled job to work queue"
        entry.work!
        if entry.repeat
          add(entry.job, every: entry.repeat)
        end
      end
      next_job = @schedules.first
      if next_job
        sleep(next_job.at - now)
      end
    end
  end

  def entries_due(time)
    [].tap do |entries|
      sync do
        while @schedules.first && @schedules.first[:at] <= time
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
end
