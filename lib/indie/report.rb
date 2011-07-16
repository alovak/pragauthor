module Indie
  class Report
    class Month
      attr_accessor :date, :units

      def initialize(date, units)
        @date, @units = date, units
      end

      def title
        date.strftime('%b %Y')
      end

      def name
        date.strftime('%b')
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
      @months = (0..MONTHS-1).collect do |m| 
        Month.new(Date.new(m.month.ago.year, m.month.ago.month), 0)
      end
    end

    def calculate_months_units
      data =  book.sales
                  .where("date_of_sale >= ?", MONTHS.month.ago)
                  .group("year(date_of_sale)")
                  .group("month(date_of_sale)")
                  .sum(:units)

      sales = {}

      data.each do |date, units|
        sale_date = Date.new(date[0], date[1])
        sales[sale_date] = units
      end

      @months.each do |month|
        month.units = sales[month.date] if sales[month.date]
      end
    end
  end
end
