module Indie::Report
  class Month
    attr_reader :date, :units, :vendors

    def initialize(date, units, currency)
      @date, @units = date, units
      @currency = currency
      @vendors = ::Vendor.all.collect {|vendor| Vendor.new(:model => vendor, :currency => @currency)}
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

    def money
      vendors.inject(Money.new(0, @currency)) {|sum, vendor| sum + vendor.money }
    end
  end
end
