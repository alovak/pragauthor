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
      attr_reader :units, :name

      def initialize(name, units)
        @name, @units = name, units
      end
    end

    MONTHS = 6

    attr_accessor :book
    attr_reader   :months

    def initialize(book)
      @book = book
    end

    def self.create(book)
      report = new(book)
      report.generate
      report
    end

    def generate
      initialize_months
      calculate_months_units
    end

    def initialize_months
      @month_table = {}

      @months = (0..MONTHS-1).collect do |m| 
        month = Month.new(Date.new(m.month.ago.year, m.month.ago.month), 0)
        @month_table[month.date] = month
      end

    end

    private

    def month_table(date)
      @month_table[date]
    end

    def calculate_months_units
      data =  book.sales
                  .where("date_of_sale >= ?", MONTHS.month.ago)
                  .group("year(date_of_sale)")
                  .group("month(date_of_sale)")
                  .group("vendor_id")
                  .sum(:units)

      data.each do |group, units|
        sale_date = Date.new(group[0], group[1])
        month_table(sale_date).vendors << Vendor.new(::Vendor.find(group[2]).name, units)
      end
    end
  end
end
