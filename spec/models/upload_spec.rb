require 'spec_helper'

describe Upload do
  let(:upload) { subject }
  describe "validations" do
    it "should validate presence of report" do
      upload.should_not be_valid
      upload.errors[:report].should include("can't be blank")
    end

    it "should validate processing of" do
      upload.report = File.open("#{Rails.root}/features/support/files/unknown.txt")
      upload.should_not be_valid
    end
  end
end
