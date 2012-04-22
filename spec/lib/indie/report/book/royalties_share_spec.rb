require 'spec_helper'

describe Indie::Report::Book::Royalties do
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

        it "should return rows for all months of period" do
          data = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :currency => 'USD', :period => date_range).data
          data.should have(2).records
        end

        it "should include money, amount, units for each month with USD" do
          data = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :currency => 'USD', :period => date_range).data

          data.should include({vendor: @bn.id,    money: Money.new(8000, 'USD'),})
          data.should include({vendor: @smash.id, money: Money.new(7000, 'USD')})
        end
      end

      context "without date range" do
        it "should include money, units for each month with USD for last 12 month" do
          data = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :currency => 'USD').data

          data.should include({vendor: @bn.id,    money: Money.new(9000, 'USD'),})
          data.should include({vendor: @smash.id, money: Money.new(15000, 'USD')})
        end

        it "should include money, units for each month with EUR" do
          data = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :currency => 'EUR').data

          data.should include({vendor: @smash.id, money: Money.new(11000, 'EUR')})
        end
      end
    end
  end
end

