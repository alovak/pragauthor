require 'spec_helper'

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
      bn = Vendor.find_by_name("Barnes&Noble")
      smash = Vendor.find_by_name("Smashwords")

      { "01 Jun 2010" => { :units => 3,  :vendor => bn },
        "01 Dec 2010" => { :units => 10, :vendor => bn }, 
        "01 Jan 2011" => { :units => 5,  :vendor => bn }, 
        "05 Jan 2011" => { :units => 12, :vendor => smash }, 
        "11 Feb 2011" => { :units => 35, :vendor => bn }, 
        "01 Jun 2011" => { :units => 11, :vendor => bn }, 
        "08 Jun 2011" => { :units => 4,  :vendor => smash }, 
      }.each do |date, data|
          book.sales << Factory(:sale, :units => data[:units], :vendor => data[:vendor], :book => book, :date_of_sale => Date.parse(date))
      end
    end


    it "should have 2 vendors in Jan" do
      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        report = create_report

        jan = report.months.find {|month| month.title == "Jan 2011"}

        jan.should have(2).vendors
      end
    end

    it "should have corresponding amount of units for vendors" do
      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        report = create_report

        jan = report.months.find {|month| month.title == "Jan 2011"}

        jan_vendor_units = { "Barnes&Noble" => 5, "Smashwords" => 12 }

        jan.vendors.each do |vendor|
          jan_vendor_units[vendor.name].should == vendor.units
        end

        jun = report.months.find {|month| month.title == "Jun 2011"}

        jun_vendor_units = { "Barnes&Noble" => 11, "Smashwords" => 4 }

        jun.vendors.each do |vendor|
          jun_vendor_units[vendor.name].should == vendor.units
        end
      end
    end

    it "should have last 6 month with corresponding units count" do
      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        report = create_report

        expected_sales = {
          Date.new(2011, 1) => 17,
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
