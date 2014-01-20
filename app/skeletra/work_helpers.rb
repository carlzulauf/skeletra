class Skeletra
  module WorkHelpers
    def enqueue(job = nil, &block)
      Skeletra.work.enqueue job, &block
    end

    alias_method :in_background, :enqueue

    def schedule
      Skeletra.schedule
    end

    def work
      Skeletra.work
    end
  end
end
