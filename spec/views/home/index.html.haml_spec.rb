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

  context "when book exists" do
    let(:vendor) { Vendor.find_by_name('Barnes&Noble') }
    let(:book) { Factory(:book) }

    before do
      assign(:books, [book])
    end

    context "and book title contains ' and \"" do
      before do
        book.title = %Q{The "Book 'Super Name}
      end

      it "should correctly display title" do
        render

        rendered.should =~ /The \"Book &apos;Super Name/
      end
    end

    it "should display sales for the last 6 month" do
      { "01 Jun 2010" => 3, 
        "01 Dec 2010" => 10, 
        "01 Jan 2011" => 5, 
        "01 Jun 2011" => 11, 
        "08 Jun 2011" => 4 
      }.each do |date, units|
          book.sales << Factory(:sale, :units => units, :book => book, :vendor => vendor, :date_of_sale => Date.parse(date))
      end

      render

      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        render

        rendered.should =~ /Jun: 15/
        rendered.should =~ /Jan: 5/
        rendered.should_not =~ /Jun: 3/
        rendered.should_not =~ /Dec: 10/
      end
    end

    context "when book has no sales" do
      before { book.sales.delete_all }

      it "should display 6 month back with 0 units sold" do
        Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
          render
          %w(Jan Feb Mar Apr May Jun).each do |month|
            rendered.should have_tag(".months .month [title='#{month} 2011']")
            rendered.should =~ /#{month}: 0/
          end
        end
      end
    end

    context "and when book has sales" do
      before do
        book.sales << Factory(:sale, :units => 11, :book => book, :vendor => vendor, :date_of_sale => Date.parse("08 Jun 2011"))
        book.sales << Factory(:sale, :units => 4, :book => book, :vendor => vendor, :date_of_sale => Date.parse("09 Jun 2011"))
        book.sales << Factory(:sale, :units => 9, :book => book, :vendor => vendor, :date_of_sale => Date.parse("01 May 2011"))
      end

      it "should display total" do
        render

        rendered.should =~ /total: 24/
      end

      it "should diplay total for vendor" do
        render

        rendered.should =~ /Barnes&amp;Noble: 24/
      end
    end
  end
end
