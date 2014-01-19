class Skeletra::Schedule
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @schedules = []
    @watcher = Thread.new{ watch }
  end

  def add(*args)
    options = args.last.kind_of?(Hash) ? args.pop : {}
    seconds = (options[:in] || options[:every])
    at = if seconds
      Time.now + seconds
    elsif options[:at]
      options[:at]
    end
    entry = Entry.new(at, args.first, options[:every])
    @semaphore.synchronize do
      @schedules << entry
      @schedules.sort_by!(&:at)
    end
    if @watcher.stop?
      @watcher.wakeup
    end
  end

  def clear
    @semaphore.synchronize{ @schedules.clear }
  end

  def watch
    loop do
      if @schedules.empty?
        Thread.stop
      end
      now = Time.now
      entries = []
      @semaphore.synchronize do
        while @schedules.first && @schedules.first[:at] <= now
          entries << @schedules.shift
        end
      end
      entries.each do |entry|
        log.info "Adding scheduled job to work queue"
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
  rescue Exception => e
    log.error e.inspect
    log.error e.backtrace
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
