require 'ostruct'

module HomeHelper
  def monthly_sales(book, options)
    sales = {}

    (0..options[:months]-1).collect do |m| 
      sale_date = Date.new(m.month.ago.year, m.month.ago.month)
      sales[sale_date] = 0
    end

    real_sales =  book.sales
                        .where("date_of_sale >= ?", options[:months].month.ago)
                        .group("year(date_of_sale)")
                        .group("month(date_of_sale)")
                        .sum(:units)

    real_sales.each do |date, units|
      sale_date = Date.new(date[0], date[1])
      sales[sale_date] = units
    end

    sales
  end
end
