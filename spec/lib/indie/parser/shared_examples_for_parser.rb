shared_context "parser stuff" do
  let(:user) { Factory(:user) }
  let(:parser) { described_class.new(file, user) }
  let(:vendor) { Vendor.find_by_name(described_class::VENDOR_NAME) } 
end

shared_examples "a parser" do
  include_context "parser stuff"

  describe "#process" do
    it "should create books for user" do
      expect { parser.process }.to change{ user.books.count }.from(0).to(4)
    end

    it "should create books with corresponding titles" do
      parser.process

      ['The First Book', 'The Second Book', 'The Third Book', 'The Fourth Book'].each do |title|
        book = Book.find_by_title(title)
        book.should_not be_nil
      end
    end

    it "should create sales" do
      expect { parser.process }.to change { Sale.count }.from(0).to(30)
    end

    it "should assign a vendor to all sales" do
      expect { parser.process }.to change { vendor.sales.count }.from(0).to(30)
    end

    it "should create sales with units for the books" do
      parser.process

      { 'The First Book'  => 21, 
        'The Second Book' => 4,
        'The Third Book' => 8,
        'The Fourth Book' => 3,
      }.each do |title, units|
        book = Book.find_by_title(title)
        book.sales.sum(:units).should == units
      end
    end
  end
end


shared_examples "a parser for daily sales"do
  include_context "parser stuff"

  describe "#process" do
    it "should create sales with dates" do
      parser.process
      [
        '21 Aug 2010', '22 Aug 2010', '23 Aug 2010', '25 Aug 2010', '31 Aug 2010', 
        '1 Oct 2010', '10 Oct 2010', '17 Jan 2011', '20 Jan 2011', '4 Feb 2011', 
        '1 Mar 2011', '9 Aug 2010', '10 Aug 2010', '16 Aug 2010', '17 Aug 2010'
      ].each do |date|
        Sale.find_by_date_of_sale(DateTime.parse(date)).should_not be_nil
      end

      Sale.where(:date_of_sale => DateTime.parse('18 Aug 2010')).all.should have(3).sales
      Sale.where(:date_of_sale => DateTime.parse('30 May 2011')).all.should have(3).sales
    end
  end
end
