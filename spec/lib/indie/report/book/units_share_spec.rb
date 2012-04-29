require 'spec_helper'

describe Indie::Report::Book::Units do
  context "when author has sales" do
    before do
      Timecop.travel(Chronic.parse("31 Dec 2011"))

      @book = Factory(:book)

      @bn = Vendor.find_by_name("Barnes&Noble")
      @smash = Vendor.find_by_name("Smashwords")

      { "01 Jan 2010" => { :units => 1, :vendor => @bn,    :amount => 1000,  :currency => 'USD' },

        # last year
        "21 Sep 2011" => { :units => 3, :vendor => @bn,    :amount => 7000,  :currency => 'USD' }, 
        "25 Sep 2011" => { :units => 3, :vendor => @smash, :amount => 7000,  :currency => 'USD' }, 
        "28 Sep 2011" => { :units => 3, :vendor => @smash, :amount => 3000,  :currency => 'EUR' }, 
        "28 Nov 2011" => { :units => 4, :vendor => @bn,    :amount => 2000,  :currency => 'USD' }, 
        "29 Nov 2011" => { :units => 5, :vendor => @smash, :amount => 8000,  :currency => 'USD' }, 
        "30 Nov 2011" => { :units => 6, :vendor => @smash, :amount => 8000,  :currency => 'EUR' }, 
      }.each do |date, data|
        @book.sales << Factory(:sale, data.update(:book => @book, :date_of_sale => Chronic.parse(date)))
      end
    end

    after do
      Timecop.return
    end

    describe "#data" do
      context "with date range" do
        let(:date_range) { DateRange.new(:from => 'January 2010', :to => 'September 2011') }

        it "should return rows for two vendors" do
          data = Indie::Report::Book::UnitsShare.new(@book.sales, period: date_range).data
          data.should have(2).records
        end

        it "should include units for each month for each vendor" do
          data = Indie::Report::Book::UnitsShare.new(@book.sales, period: date_range).data

          data.should include({vendor: @bn.id,    units: 4})
          data.should include({vendor: @smash.id, units: 6})
        end
      end

      context "without date range" do
        it "should include units for last 12 month" do
          data = Indie::Report::Book::UnitsShare.new(@book.sales).data

          data.should include({vendor: @bn.id,    units: 7})
          data.should include({vendor: @smash.id, units: 17})
        end
      end
    end
  end
end

