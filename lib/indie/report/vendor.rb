module Indie::Report
  class Vendor
    attr_accessor :units, :money, :last_n_units, :last_n_money
    attr_reader   :model

    delegate :name, :to => :model

    def initialize(params = {})
      @model = params[:model] 
      @currency = params[:currency] 

      @units = params[:units] || 0
      @last_n_units = params[:last_n_units] || 0

      @money = params[:money] || Money.new(0, @currency)
      @last_n_money = params[:last_n_money] || Money.new(0, @currency)
    end
  end
end
