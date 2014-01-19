class Skeletra
  class WorkQueue
    include Singleton

    attr_reader :queue, :pool

    def initialize
      @queue = TimeoutQueue.new
      @pool = Set.new
    end

    def enqueue(job = nil, &block)
      # log.info "WorkQueue#enqueue(#{job.inspect}, block? #{block_given?})"
      if block_given?
        enqueue BlockJob.new(block)
      else
        log.info "Adding job to work queue"
        @queue.push(job).tap{ check_workers }
      end
    end

    alias_method :enqueue_block, :enqueue

    def grab
      @queue.pop
    end

    def max_workers
      4
    end

    def check_workers
      pool_size = pool.size
      queue_size = queue.size
      log.info "Checking workers. Pool: #{pool_size}, Max: #{max_workers}, Queue: #{queue_size}"
      # log.debug "Pool: #{pool.inspect}"
      if pool_size < max_workers
        add_worker if pool_size == 0 || queue_size > max_workers
      end
    end

    def add_worker
      log.info "Adding new worker to pool"
      Worker.new(pool.size).work(self)
    end

    def log
      Skeletra.logger
    end

    class Worker
      def initialize(id)
        @id = id
      end

      def work(work)
        Thread.start do
          work.pool.add Thread.current
          while job = work.grab
            log.info "Worker ##{@id} has grabbed a job"
            begin
              job.perform
            rescue Exception => e
              log.error %|Worker ##{@id} error: #{e.message}\n#{e.backtrace.join("\n")}|
            end
          end
          log.debug "Worker removing self from pool"
          work.pool.delete Thread.current
        end
      end

      def log
        Skeletra.logger
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
