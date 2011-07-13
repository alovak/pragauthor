require 'spec_helper'

describe HomeHelper do
  let(:book) { Factory(:book) }

  describe "#monthly_sales" do
    context "when there are sales for different dates" do
      before do
        { "01 Jun 2010" => 3, 
          "01 Dec 2010" => 10, 
          "01 Jan 2011" => 5, 
          "11 Feb 2011" => 35, 
          "01 Jun 2011" => 11, 
          "08 Jun 2011" => 4 
        }.each do |date, units|
            book.sales << Factory(:sale, :units => units, :book => book, :date_of_sale => Date.parse(date))
        end
      end

      it "should return sales for the last 6 month with corresponding units count" do
        Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
          sales = helper.monthly_sales(book, { :months => 6} )

          expected_sales = {
            Date.new(2011, 1) => 5,
            Date.new(2011, 2) => 35,
            Date.new(2011, 3) => 0,
            Date.new(2011, 4) => 0,
            Date.new(2011, 5) => 0,
            Date.new(2011, 6) => 15,
          }

          sales.each do |date, units|
            units.should == expected_sales[date]
          end
        end
      end
    end

    context "when there are no sales for the book" do
      before { book.sales.delete_all }

      it "returns 6 month with 0 units sold" do
        Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do

          expected_dates = (1..6).collect {|m| Date.new(2011, m)}

          sales = helper.monthly_sales(book, { :months => 6} )

          sales.should have(6).items

          sales.each do |date, units|
            expected_dates.should include(date)
            units.should == 0
          end
        end
      end
    end
  end
end
