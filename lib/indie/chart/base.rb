module Indie::Chart
  module HelperMethods
    def months
      @months ||= begin
        months = []
        date = @date_range.from_date
        while (date <= @date_range.to_date)
          months << Date.new(date.year, date.month)
          date = date >> 1
        end
        months
      end
    end
  end

  module Base
    class Units
      include HelperMethods

      def initialize(sales, options = {})
        @sales = sales
        @top_books = options[:top] || 5
        @date_range = options[:period] || DateRange.new
        @show_trend = options[:show_trend]
      end

      def data
        @data ||= { 
          cols: cols,
          rows: rows
        }
      end

      def show_trend?
        @show_trend == true
      end

      private

      def cols

        [].tap do |cols|
          cols << { label: 'Month', type: 'string' }

          items.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }

          if show_trend?
            cols << { label: 'Average', type: 'number' }
            cols << { label: 'Totals',  type: 'number' }
          end
        end
      end

      def rows
        [].tap do |rows|
          months.each do |month|
            row = { c: [] }

            row[:c] << { v: month.strftime('%b') }

            sum = 0

            items.each do |item|
              raw_key = [month.year, month.month, item.id]
              units = raw_data[raw_key] || 0

              sum = sum + units

              row[:c] << { v: units }
            end

            if show_trend? && items.any?
              row[:c] << { v: sum/items.count }
              row[:c] << { v: sum }
            end

            rows << row
          end
        end
      end
    end
    class Money 
      include HelperMethods

      def initialize(sales, options = {})
        @sales = sales
        @top_books = options[:top] || 5
        @date_range = options[:period] || DateRange.new
        @show_trend = options[:show_trend]
        @currency   = options[:currency] || 'USD'
      end

      def data
        @data ||= { 
          cols: cols,
          rows: rows
        }
      end

      def show_trend?
        @show_trend == true
      end

      private

      def cols
        [].tap do |cols|
          cols << { label: 'Month', type: 'string' }

          items.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }

          if show_trend?
            cols << { label: 'Average', type: 'number' }
            cols << { label: 'Totals',  type: 'number' }
          end
        end
      end

      def rows
        [].tap do |rows|
          months.each do |month|
            row = { c: [] }

            row[:c] << { v: month.strftime('%b') }

            sum = 0

            items.each do |item|
              raw_key = [month.year, month.month, item.id]
              units = raw_data[raw_key] || 0

              sum = sum + units

              row[:c] << { v: ::Money.new(units, @currency).dollars, f: ::Money.new(units, @currency).format }
            end

            if show_trend? && items.any?
              row[:c] << { v: ::Money.new(sum/items.count, @currency).dollars, f: ::Money.new(sum/items.count, @currency).format }
              row[:c] << { v: ::Money.new(sum, @currency).dollars, f: ::Money.new(sum, @currency).format }
            end

            rows << row
          end
        end
      end
    end
  end
end
