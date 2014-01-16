class Skeletra
  module WorkHelpers
    def in_background(&block)
      Skeletra.work.enqueue_block &block
    end

    def enqueue(job = nil, &block)
      if block_given?
        in_background &block
      else
        Skeletra.work.enqueue job
      end
    end
  end
end
