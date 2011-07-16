require 'spec_helper'

# I would like to use API by the following:
#
# Report.create(book)
# Report.months.each do |month|
#   puts month.name
#   puts month.units
#   month.vendors.each do |vendor|
#     puts vendor.name
#     puts vendor.units
#   end
# end

describe Indie::Report do
  let(:book) { Factory(:book) }

  def create_report
    report = Indie::Report.create(book)
  end

  context "when book has no any sales" do
    it "should contain 6 month" do
      report = create_report
      report.should have(6).months
    end

    it "should have 0 units for each month" do
      report = create_report
      report.months.each do |month|
        month.units.should == 0
      end
    end
  end

  context "when book has sales" do
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
        report = create_report

        expected_sales = {
          Date.new(2011, 1) => 5,
          Date.new(2011, 2) => 35,
          Date.new(2011, 3) => 0,
          Date.new(2011, 4) => 0,
          Date.new(2011, 5) => 0,
          Date.new(2011, 6) => 15,
        }

        report.months.each do |month|
          month.units.should == expected_sales[month.date]
        end
      end
    end
  end
end
