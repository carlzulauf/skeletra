require "spec_helper"

describe Skeletra::Schedule do
  before :each do
    @schedule = Skeletra::Schedule.instance
  end
  describe "#add" do
    it "should allow a job to be processed after specified delay" do
      job = double("job")
      expect(job).to receive(:perform)
      @schedule.add(job, :in => 1)
      sleep 2
    end

    it "should allow a job to be processed at the specified time" do
      job = double("job")
      expect(job).to receive(:perform)
      @schedule.add(job, :at => Time.now + 1)
      sleep 2
    end
  end
end
