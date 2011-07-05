require 'spec_helper'

describe "home/index.html.haml" do
  before { assign(:books, []) }

  it "should contain form with file field to upload report" do
    render

    rendered.should have_selector("form[action='#{uploads_path}'][method='post'][enctype='multipart/form-data']")
    rendered.should have_selector("input[type='file']", :name => "upload[report]")
  end

  it "should show instructions how to upload file" do
    render

    rendered.should include("You didn't upload any report yet")
  end

  context "with 2 books" do
    before do
      assign(:books, [
        stub_model(Book, :title => "First Book"),
        stub_model(Book, :title => "Second Book")
      ])
    end

    it "should display book titles" do
      render

      rendered.should =~ /First Book/
      rendered.should =~ /Second Book/
    end
  end

  context "with book when book has sales" do
    before do
      book = Factory(:book)

      book.sales << Factory(:sale, :units => 11, :book => book)
      book.sales << Factory(:sale, :units => 9, :book => book)

      assign(:books, [book])
    end

    it "should display total" do
      render

      rendered.should =~ /total: 20/
    end
  end
end
