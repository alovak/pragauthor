module Indie
  module Chart
    class Money
      def initialize(sales, options = {})
        @sales = sales
        @top_books = options[:top] || 5
        @period = options[:period] || 6
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

      def months
        (@period-1).downto(0).collect { |m| Date.new(m.month.ago.year, m.month.ago.month) }
      end

      def raw_data
        @sales
          .where("date_of_sale > ? and book_id in (?) and currency = ?", @period.month.ago.end_of_month, top_book_ids, @currency)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:amount)
      end

      def top_book_ids
        @sales
          .where("date_of_sale > ? and currency = ?", @period.month.ago.end_of_month, @currency)
          .group(:book_id)
          .order('sum_amount DESC')
          .limit(@top_books)
          .sum(:amount).keys
      end
    end

    class Sales
      def initialize(sales, options = {})
        @sales = sales
        @top_books = options[:top] || 5
        @period = options[:period] || 6
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

      def months
        (@period-1).downto(0).collect { |m| Date.new(m.month.ago.year, m.month.ago.month) }
      end

      def raw_data
        @sales
          .where("date_of_sale > ? and book_id in (?)", @period.month.ago.end_of_month, top_book_ids)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:units)
      end

      def top_book_ids
        @sales
          .where("date_of_sale > ?", @period.month.ago.end_of_month)
          .group(:book_id)
          .order('sum_units DESC')
          .limit(@top_books)
          .sum(:units).keys
      end
    end
  end
end