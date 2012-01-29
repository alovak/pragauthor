module Indie
  module Parser
    class Amazon < Base

      VENDOR_NAME       = 'Amazon'

      TITLE             = 0
      UNIT_NET_SALES    = 4
      CURRENCY          = 10
      REVENUE           = 10

      BOOKS_OFFSET      = 4
      CURRENCY_OFFSET   = 1
      SALE_DATE_OFFSET  = 2

      def process
        sheet.each do |row|
          process_books_for_store(row.idx) if beginning_of_the_block?(row) && block_has_sales?(row)
        end
      end

      private

      def process_books_for_store(header_row_id)
        sale_date = convert_date(sheet.row(header_row_id + SALE_DATE_OFFSET)[0])
        currency = get_currency(sheet.row(header_row_id + CURRENCY_OFFSET)[CURRENCY])

        sheet.each(header_row_id + BOOKS_OFFSET) do |row|
          return if end_of_block?(row)

          book = find_or_create_book(row[TITLE])
          create_sale(book, :units => row[UNIT_NET_SALES], 
                            :date_of_sale => sale_date, 
                            :amount => row[REVENUE].to_money.cents,
                            :currency => currency)
        end
      end

      def sheet
        @sheet ||= begin
                     book  = Spreadsheet.open(@file_path)
                     sheet = book.worksheet 0
                   end
      end

      def beginning_of_the_block?(row)
        row[TITLE] =~ /Title/i
      end

      def end_of_block?(row)
        row[TITLE] =~ /Total Royalty for Sales/i
      end

      def block_has_sales?(row)
        sheet.row(row.idx + BOOKS_OFFSET)[0] !~ /There were no sales during this period/i
      end

      def get_currency(currency)
        currency.gsub(/\(|\)| /, '')
      end

      def convert_date(date)
        # match with:
        #   Sales report for the period 01-Apr-2011 to 30-Apr-2011
        matches = date.match(/period (\d{2}-\w{3}-\d{4}) to/)
        DateTime.strptime(matches[1], '%d-%b-%Y')
      end
    end
  end
end
