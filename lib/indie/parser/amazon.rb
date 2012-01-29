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
        @book = Spreadsheet.open(@file_path)
        sheet = @book.worksheet 0

        sheet.each do |row|
          process_books_for_store(sheet, row.idx) if beginning_of_the_block?(row)
        end
      end

      private

      def beginning_of_the_block?(row)
        row[TITLE] =~ /Title/i
      end

      def end_of_block?(row)
        row[TITLE] =~ /Total Royalty for Sales/i
      end

      def process_books_for_store(sheet, header_row_id)
        return if sheet.row(header_row_id + BOOKS_OFFSET)[0] =~ /There were no sales during this period/i

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
