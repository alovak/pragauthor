require 'spec_helper'

describe Indie::Report do
  BN_BOOK_PRICE = 500
  SMASH_BOOK_PRICE = 600

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

    it "should return 0 USD as money for each vendor" do
      report = create_report

      report.vendors.each do |vendor|
        vendor.money.should == Money.new(0, 'USD')
      end
    end

    it "should return 0 units for each vendor" do
      report = create_report

      report.vendors.each do |vendor|
        vendor.units.should == 0
      end
    end
  end


  context "when book has sales" do

    before do
      bn = Vendor.find_by_name("Barnes&Noble")
      smash = Vendor.find_by_name("Smashwords")

      { "01 Jun 2010" => { :units => 3,  :vendor => bn,    :amount => 3*BN_BOOK_PRICE,     :currency => 'USD' },
        "01 Dec 2010" => { :units => 10, :vendor => bn,    :amount => 10*BN_BOOK_PRICE,    :currency => 'USD' }, 
        "01 Jan 2011" => { :units => 5,  :vendor => bn,    :amount => 5*BN_BOOK_PRICE,     :currency => 'USD'  }, 
        "09 Dec 2010" => { :units => 12, :vendor => smash, :amount => 12*SMASH_BOOK_PRICE, :currency => 'USD' }, 
        "05 Jan 2011" => { :units => 12, :vendor => smash, :amount => 12*SMASH_BOOK_PRICE, :currency => 'USD' }, 
        "11 Feb 2011" => { :units => 35, :vendor => bn,    :amount => 35*BN_BOOK_PRICE,    :currency => 'USD' }, 
        "01 Jun 2011" => { :units => 11, :vendor => bn,    :amount => 11*BN_BOOK_PRICE,    :currency => 'USD' }, 
        "08 Jun 2011" => { :units => 4,  :vendor => smash, :amount => 4*SMASH_BOOK_PRICE,  :currency => 'USD' }, 
      }.each do |date, data|
        book.sales << Factory(:sale, data.update(:book => book, :date_of_sale => Chronic.parse(date)))
      end
    end

    it "should return total units for each vendor" do
      report = create_report

      report.vendors.each do |vendor|
        vendor.units.should == 64 if vendor.name == "Barnes&Noble"
        vendor.units.should == 28 if vendor.name == "Smashwords"
      end

      report.total_units.should == 92
    end

    it "should return money for each vendor" do
      report = create_report

      report.vendors.each do |vendor|
        vendor.money.should == Money.new(64*BN_BOOK_PRICE, 'USD')    if vendor.name == "Barnes&Noble"
        vendor.money.should == Money.new(28*SMASH_BOOK_PRICE, 'USD') if vendor.name == "Smashwords"
      end

      report.total_money.should == Money.new(64*BN_BOOK_PRICE, 'USD') + Money.new(28*SMASH_BOOK_PRICE, 'USD')
    end

    it "should return units for each vendor for the last 6 month" do
      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        report = create_report

        report.vendors.each do |vendor|
          vendor.last_n_units.should == 51 if vendor.name == "Barnes&Noble"
          vendor.last_n_units.should == 16 if vendor.name == "Smashwords"
        end

        report.total_last_n_units.should == 51+16
      end
    end

    it "should return money for each vendor for the last 6 month" do
      Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) do
        report = create_report

        report.vendors.each do |vendor|
          vendor.last_n_money.should == Money.new(51*BN_BOOK_PRICE, 'USD')    if vendor.name == "Barnes&Noble"
          vendor.last_n_money.should == Money.new(16*SMASH_BOOK_PRICE, 'USD') if vendor.name == "Smashwords"
        end

        report.total_last_n_money.should == Money.new(51*BN_BOOK_PRICE, 'USD') + Money.new(16*SMASH_BOOK_PRICE, 'USD')
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
