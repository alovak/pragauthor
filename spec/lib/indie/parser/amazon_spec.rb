require 'spec_helper'

describe Indie::Parser::Amazon do
  let(:file) do
    "#{Rails.root}/features/support/files/kdp-report-04-2011.xls"
  end

  let(:parser) do
    described_class.new(file)
  end

  context "when there are no any books in the app" do
    before do
      Book.delete_all
    end

    context "and file was processed" do
      before do
        parser.process
      end

      it "should create books" do
        Book.count.should == 3
      end

      it "should create books with corresponding titles" do
        ['The First Book', 'The Second Book', 'The Third Book'].each do |title|
          book = Book.find_by_title(title)
          book.should_not be_nil
        end
      end

      it "should create sales" do
        Sale.count.should == 3
      end

      it "should create sales with correct dates" do
        Sale.where(:date_of_sale => DateTime.parse('1 Apr 2011')).all.should have(3).sales
      end

      it "should create sales with units for the books" do
        { 'The First Book'  => 190, 
          'The Second Book' => 13,
          'The Third Book'  => 5
        }.each do |title, units|
          book = Book.find_by_title(title)
          book.sales.sum(:units).should == units
        end
      end

      it "should assign 'Amazon' as vendor to all sales" do
        bn = Vendor.find_by_name('Amazon')

        Sale.all.each do |sale|
          sale.vendor.should == bn
        end
      end
    end
  end
end
