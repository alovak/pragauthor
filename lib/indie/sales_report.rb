module Indie
  class SalesReport
    def initialize(sales, date_range = nil)
      @sales = sales
      @date_range = date_range
    end

    def units
      data = @sales
      data = data.where(period_conditons) if @date_range
      data.sum(:units)
    end

    def money
      data = @sales
      data = data.where(period_conditons) if @date_range
      data = data.group(:currency).sum(:amount)

      [].tap do |money_collection|
        data.each do |currency, amount|
          money_collection << Money.new(amount, currency) if amount != 0
        end
      end
    end

    private

    def period_conditons
      ["date_of_sale >= ? AND date_of_sale <= ?", @date_range.from_date, @date_range.to_date]
    end
  end
end
