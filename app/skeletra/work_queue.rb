class Skeletra
  class WorkQueue
    include Singleton

    attr_reader :queue, :pool

    def initialize
      @queue = TimeoutQueue.new
      @pool = Set.new
    end

    def enqueue(job)
      log "WorkQueue#enqueue called: #{job.inspect}"
      @queue.push(job).tap{ check_workers }
    end

    def enqueue_block(&block)
      enqueue BlockJob.new(block)
    end

    def grab
      log "WorkQueue#grab called"
      @queue.pop
    end

    def max_workers
      4
    end

    def check_workers
      log "WorkQueue#check_workers called"
      pool_size = @pool.size
      if pool_size < max_workers
        add_worker if pool_size == 0 || @queue.size > max_workers
      end
    end

    def add_worker
      log "WorkQueue#add_worker called"
      Worker.new.work(self)
    end

    def log(msg)
      # Skeletra.logger.info msg
    end

    class Worker
      def work(work)
        Thread.start do
          work.pool.add Thread.current
          while job = work.grab
            job.perform
          end
          work.pool.delete Thread.current
        end
      end
    end

    class BlockJob
      def initialize(block)
        @block = block
      end

      def perform
        @block.call
      end
    end

    class TimeoutQueue
      include Timeout

      def initialize
        @queue = Queue.new
      end

      def push(item)
        @queue << item
        true
      end

      def pop(seconds = 5)
        timeout(seconds) { @queue.pop }
      rescue Timeout::Error
        nil
      end

      def size
        @queue.size
      end
    end
  end
end
