require 'spec_helper'

describe "home/index.html.haml" do
  before { assign(:sales, Sale) }

  context "when there are no books" do
    before { assign(:books, []) }

    it "should show instructions how to upload file" do
      render

      rendered.should include("You didn't upload any report yet")
    end
  end

  it "should contain form with file field to upload report" do
    render

    rendered.should have_selector("form[action='#{uploads_path}'][method='post'][enctype='multipart/form-data']")
    rendered.should have_selector("input[type='file']", :name => "upload[report]")
  end

  context "when author has books" do
    before { assign(:books, [Factory(:book)]) }
    it "should contain form with date range selector" do
      render

      rendered.should have_selector("form[action=''][method='get']")
      rendered.should have_selector("select[name='date_range[from]']")
    end

  end
end
