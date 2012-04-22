module Indie::Report::Book
  class Royalties
    def initialize(sales, params = {})
      @sales = sales
      @currency = params[:currency] || 'USD'
      @period = params[:period] || DateRange.new
    end

    def data
      @data ||= begin
                  i = 0
                  months = {}

                  while (@period.from_date + i.month < @period.to_date )
                    date = @period.from_date + i.month
                    months[date] = { money: Money.new(0, @currency), units: 0 }
                    i = i +1
                  end

                  data = @sales
                    .select("date_of_sale, SUM(amount) as amount, SUM(units) as units")
                    .group("year(date_of_sale)")
                    .group("month(date_of_sale)")
                    .where(:currency => @currency)
                    .where(["date_of_sale >= ? AND date_of_sale <= ?", @period.from_date, @period.to_date])
                    .each { |s| months[s.date_of_sale.to_date.beginning_of_month] = {money: Money.new(s.amount, @currency), units: s.units } }

                  months.collect {|date, values| values.update(date: date) }
                end
    end
  end
end
