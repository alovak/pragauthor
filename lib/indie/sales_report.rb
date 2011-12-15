module Indie
  class SalesReport
    def initialize(sales)
      @sales = sales
    end

    def units
      @sales.sum(:units)
    end

    def money
      data = @sales.group(:currency).sum(:amount)

      [].tap do |money_collection|
        data.each do |currency, amount|
          money_collection << Money.new(amount, currency) if amount != 0
        end
      end
    end
  end
end
