require 'spec_helper'

describe "home/index.html.haml" do
  before { assign(:books, []) }
  before { assign(:sales, Sale) }

  it "should contain form with file field to upload report" do
    render

    rendered.should have_selector("form[action='#{uploads_path}'][method='post'][enctype='multipart/form-data']")
    rendered.should have_selector("input[type='file']", :name => "upload[report]")
  end

  it "should show instructions how to upload file" do
    render

    rendered.should include("You didn't upload any report yet")
  end
end
