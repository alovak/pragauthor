require 'spec_helper'

describe "home/index.html.haml" do
  
  subject { render }

  it "should contain form with file field to upload report" do
    should have_selector("form[action='#{uploads_path}'][method='post'][enctype='multipart/form-data']")
    should have_selector("input[type='file']", :name => "upload[report]")
  end
end
