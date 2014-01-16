require "spec_helper"

class TestJob
  attr_reader :status
  def initialize
    @status = :new
  end
  def perform
    @status = :started
    sleep 1
    @status = :finished
  end
end

describe Skeletra::WorkQueue do
  before :each do
    @work = Skeletra::WorkQueue.instance
  end
  describe "#enqueue" do
    it "should allow a job to be queued without error" do
      expect(@work.enqueue TestJob.new).to be_true
    end

    it "should work jobs eventually" do
      job = TestJob.new
      expect(job.status).to equal(:new)
      @work.enqueue(job)
      sleep 5
      expect(job.status).to equal(:finished)
    end
  end

  describe "#enqueue_block" do
    it "should allow blocks to be executed in the background" do
      $shared = 0
      @work.enqueue_block do
        sleep 1
        $shared += 1
      end
      expect($shared).to eq(0)
      sleep 2
      expect($shared).to eq(1)
    end
  end
end
