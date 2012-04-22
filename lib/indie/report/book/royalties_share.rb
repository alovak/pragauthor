module Indie::Report::Book
  class RoyaltiesShare
    def initialize(sales, params = {})
      @sales = sales
      @currency = params[:currency] || 'USD'
      @period = params[:period] || DateRange.new
    end

    def data
      data = @sales
        .where(:currency => @currency)
        .where(["date_of_sale >= ? AND date_of_sale <= ?", @period.from_date, @period.to_date])
        .group(:vendor_id)
        .sum(:amount)
        .collect {|k, v| {vendor: k, money: Money.new(v, @currency)} }
    end
  end
end

