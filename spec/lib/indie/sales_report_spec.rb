require 'spec_helper'

describe Indie::SalesReport do
  context "when author has sales" do
    before do
      Timecop.travel(Chronic.parse("31 Dec 2011"))

      @book = Factory(:book)

      bn = Vendor.find_by_name("Barnes&Noble")
      smash = Vendor.find_by_name("Smashwords")

      { "01 Jan 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' },
        "05 Feb 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
        "10 Jun 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD'  }, 
        "20 Dec 2010" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
        "02 Jan 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
        "07 Mar 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
        "21 Sep 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
        "30 Nov 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
      }.each do |date, data|
        @book.sales << Factory(:sale, data.update(:book => @book, :date_of_sale => Chronic.parse(date)))
      end
    end

    after do
      Timecop.return
    end

    context "without date range" do
      subject { Indie::SalesReport.new(@book.sales) }
      its(:units) { should == 8 }
      its(:money) { should include("$80.00") }
    end


    context "with date range" do
      let(:date_range) { DateRange.new(:from => 'January 2010', :to => 'December 2010') }
      subject { Indie::SalesReport.new(@book.sales, date_range) }
      its(:units) { should == 4 }
      its(:money) { should include("$40.00") }
    end
  end
end
