module Indie::Report::Book
  class Units
    def initialize(sales, params = {})
      @sales = sales
      @period = params[:period] || DateRange.new
    end

    def data
      @data ||= begin
                  i = 0
                  months = {}

                  while (@period.from_date + i.month < @period.to_date )
                    date = @period.from_date + i.month
                    months[date] = { units: 0 }
                    i = i +1
                  end

                  data = @sales
                    .select("date_of_sale, SUM(units) as units")
                    .group("year(date_of_sale)")
                    .group("month(date_of_sale)")
                    .where(["date_of_sale >= ? AND date_of_sale <= ?", @period.from_datetime, @period.to_datetime])
                    .each { |s| months[s.date_of_sale.to_date.beginning_of_month] = { units: s.units } }

                  months.collect {|date, values| values.update(date: date) }
                end
    end
  end
end
