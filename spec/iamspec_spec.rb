require "spec_helper"

describe Iamspec do
  it "has a version number" do
    expect(Iamspec::VERSION).not_to be nil
  end

  describe "iamuser to string" do
    it "should look good" do
      expect(iam_user("SomeUser").to_s).to eq('IAM User "SomeUser"')
    end
  end
end
