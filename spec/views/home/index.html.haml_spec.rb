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

  context "book exists" do
    let(:vendor) { Vendor.find_by_name('Barnes&Noble') }
    let(:book) { Factory(:book) }

    before do
      assign(:books, [book])
    end

    context "book title contains ' and \"" do
      before do
        book.title = %Q{The "Book 'Super Name}
      end

      it "should correctly display title" do
        render

        rendered.should =~ /The \"Book &apos;Super Name/
      end
    end

    context "and when book has sales" do
      before do
        book.sales << Factory(:sale, :units => 11, :book => book, :vendor => vendor)
        book.sales << Factory(:sale, :units => 9, :book => book, :vendor => vendor)
      end

      it "should display total" do
        render

        rendered.should =~ /total: 20/
      end

      it "should diplay total for vendor" do
        render

        rendered.should =~ /Barnes&Noble: 20/
      end
    end
  end
end
