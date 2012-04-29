require 'spec_helper'

describe Indie::Report::Book::Units do
  context "when author has sales" do
    before do
      Timecop.travel(Chronic.parse("31 Dec 2011"))

      @book = Factory(:book)

      bn = Vendor.find_by_name("Barnes&Noble")
      smash = Vendor.find_by_name("Smashwords")

      { "01 Jan 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' },
        "21 Sep 2011" => { :units => 3, :vendor => bn,    :amount => 7000,  :currency => 'USD' }, 
        "28 Nov 2011" => { :units => 4, :vendor => bn,    :amount => 2000,  :currency => 'USD' }, 
        "29 Nov 2011" => { :units => 5, :vendor => smash, :amount => 8000,  :currency => 'USD' }, 
        "30 Nov 2011" => { :units => 6, :vendor => smash, :amount => 8000,  :currency => 'EUR' }, 
      }.each do |date, data|
        @book.sales << Factory(:sale, data.update(:book => @book, :date_of_sale => Chronic.parse(date)))
      end
    end

    after do
      Timecop.return
    end

    def report_data(sales, params = {})
      Indie::Report::Book::Units.new(sales, params).data
    end

    describe "#data" do
      context "with date range" do
        let(:date_range) { DateRange.new(:from => 'January 2010', :to => 'November 2011') }

        it "should return rows for all months of period" do
          data = report_data @book.sales, period: date_range
          data.should have(23).records
        end

        it "should include units for each month" do
          data = report_data(@book.sales, period: date_range)

          data.should include({date: Date.new(2010, 1), units: 1})
          data.should include({date: Date.new(2011, 9), units: 3})
          data.should include({date: Date.new(2011, 11), units: 15})
        end
      end

      context "without date range" do
        it "should include units for last 12 months" do
          data = report_data(@book.sales)

          data.should_not include({date: Date.new(2010, 1), units: 1})
          data.should include({date: Date.new(2011, 9), units: 3})
          data.should include({date: Date.new(2011, 11), units: 15})
        end
      end
    end
  end
end

