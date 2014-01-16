require "spec_helper"

describe Skeletra::Server do
  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end
end
