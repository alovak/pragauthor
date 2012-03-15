module Indie::Chart
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
        books = Book.order(:title).find(top_book_ids)

        [].tap do |cols|
          cols << { label: 'Month', type: 'string' }

          books.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }

          if show_trend?
            cols << { label: 'Average', type: 'number' }
            cols << { label: 'Totals',  type: 'number' }
          end
        end
      end

      def rows
        books = Book.order(:title).find(top_book_ids)

        [].tap do |rows|
          months.each do |month|
            row = { c: [] }

            row[:c] << { v: month.strftime('%b') }

            sum = 0

            books.each do |book|
              raw_key = [month.year, month.month, book.id]
              units = raw_data[raw_key] || 0

              sum = sum + units

              row[:c] << { v: units }
            end

            if show_trend? && books.any?
              row[:c] << { v: sum/books.count }
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
        books = Book.order(:title).find(top_book_ids)

        [].tap do |cols|
          cols << { label: 'Month', type: 'string' }

          books.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }

          if show_trend?
            cols << { label: 'Average', type: 'number' }
            cols << { label: 'Totals',  type: 'number' }
          end
        end
      end

      def rows
        books = Book.order(:title).find(top_book_ids)

        [].tap do |rows|
          months.each do |month|
            row = { c: [] }

            row[:c] << { v: month.strftime('%b') }

            sum = 0

            books.each do |book|
              raw_key = [month.year, month.month, book.id]
              units = raw_data[raw_key] || 0

              sum = sum + units

              row[:c] << { v: ::Money.new(units, @currency).dollars, f: ::Money.new(units, @currency).format }
            end

            if show_trend? && books.any?
              row[:c] << { v: ::Money.new(sum/books.count, @currency).dollars, f: ::Money.new(sum/books.count, @currency).format }
              row[:c] << { v: ::Money.new(sum, @currency).dollars, f: ::Money.new(sum, @currency).format }
            end

            rows << row
          end
        end
      end
    end
  end
end
