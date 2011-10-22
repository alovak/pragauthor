module Indie
  class Report
    class Month
      attr_reader :date, :units, :vendors

      def initialize(date, units)
        @date, @units = date, units
        @vendors = []
      end

      def title
        date.strftime('%b %Y')
      end

      def name
        date.strftime('%b')
      end

      def units
        vendors.inject(0) {|sum, vendor| sum + vendor.units  }
      end
    end

    class Vendor
      attr_accessor :units, :money
      attr_reader   :model

      delegate :name, :to => :model

      def initialize(params = {})
        @model, @units = params[:model], params[:units]
        @money = Money.us_dollar(0)
      end
    end

    MONTHS = 6

    attr_accessor :book
    attr_reader   :months, :vendors

    def initialize(book)
      @book = book
      @vendors = ::Vendor.all.collect {|vendor| Vendor.new(:model => vendor)}
    end

    def self.create(book)
      report = new(book)
      report.generate
      report
    end

    def generate
      initialize_months
      calculate_months_units
      calculate_total_vendors_money
    end

    def initialize_months
      @month_table = {}

      @months = (0..MONTHS-1).collect do |m| 
        month = Month.new(Date.new(m.month.ago.year, m.month.ago.month), 0)
        @month_table[month.date] = month
      end

    end

    private

    def calculate_total_vendors_money
      data = book.sales
                 .group("vendor_id")
                 .group("currency")
                 .sum(:amount)

      data.each do |group, amount|
        next if amount == 0

        vendor_id = group[0]
        currency  = group[1]

        if vendor = vendors.find {|vendor| vendor.model.id == vendor_id }
          vendor.money = Money.new(amount, currency)
        end
      end
    end

    def month_table(date)
      @month_table[date]
    end

    def calculate_months_units
      data =  book.sales
                  .where("date_of_sale > ?", MONTHS.month.ago.end_of_month)
                  .group("year(date_of_sale)")
                  .group("month(date_of_sale)")
                  .group("vendor_id")
                  .sum(:units)

      data.each do |group, units|
        sale_date = Date.new(group[0], group[1])
        month_table(sale_date).vendors << Vendor.new(:model => ::Vendor.find(group[2]), :units => units)
      end
    end
  end
end
