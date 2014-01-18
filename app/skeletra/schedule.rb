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
    @semaphore.synchronize do
      @schedules << Entry.new(at, args.first, options[:every])
      @schedules.sort_by!(&:at)
    end
    @watcher.wakeup if @watcher.stop?
  end

  def watch
    loop do
      Thread.stop if @schedules.empty?
      now = Time.now
      jobs = []
      next_job = nil
      @semaphore.synchronize do
        while @schedules.first && @schedules.first[:at] <= now
          jobs << @schedules.shift
        end
        next_job = @schedules.first
      end
      jobs.each do |job|
        job.work!
        add(job, every: job.repeat) if job.repeat
      end
      sleep(next_job.at - now) if next_job
    end
  end

  class Entry < Struct.new(:at, :job, :repeat)
    def work!
      Skeletra.work.enqueue job
    end
  end
end
