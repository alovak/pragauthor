shared_context "parser stuff" do
  let(:user) { Factory(:user) }
  let(:parser) { described_class.new(file, user) }
  let(:vendor) { Vendor.find_by_name(described_class::VENDOR_NAME) } 
end

shared_examples "a parser" do |expectations|
  include_context "parser stuff"

  describe "#process" do
    it "should create books for user" do
      expect { parser.process }.to change{ user.books.count }.from(0).to(expectations[:books])
    end

    it "should create books with corresponding titles" do
      parser.process

      expectations[:titles].each do |title|
        book = Book.find_by_title(title)
        book.should_not be_nil
      end
    end

    it "should create sales" do
      expect { parser.process }.to change { Sale.count }.from(0).to(expectations[:sales])
    end

    it "should assign a vendor to all sales" do
      expect { parser.process }.to change { vendor.sales.count }.from(0).to(expectations[:sales])
    end

    it "should create sales with units for the books" do
      parser.process

      expectations[:book_units].each do |title, units|
        book = Book.find_by_title(title)
        book.sales.sum(:units).should == units
      end
    end

    it "should create sales with money for the books" do
      parser.process

      expectations[:book_money].each do |title, money|
        book = Book.find_by_title(title)
        book.sales.where(:currency => money.currency.iso_code).sum(:amount).should == money.cents
      end
    end

    it "should not duplicate sales for the same file" do
      parser.process
      parser.process

      expectations[:book_units].each do |title, units|
        book = Book.find_by_title(title)
        book.sales.sum(:units).should == units
      end
    end
  end
end


shared_examples "a parser for daily sales" do |sale_dates|
  include_context "parser stuff"

  describe "#process" do
    it "should create sales with dates" do
      parser.process

      sale_dates.each do |date|
        Sale.find_by_date_of_sale(DateTime.parse(date)).should_not be_nil
      end
    end
  end
end
