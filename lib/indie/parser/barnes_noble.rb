module Indie
  module Parser
    class BarnesNoble < Base

      VENDOR_NAME       = 'Barnes&Noble'

      SKIP_ROWS       = 1
      DATE_OF_SALE    = 0
      TITLE           = 3
      UNIT_NET_SALES  = 8

      REVENUE         = 9

      CURRENCY_CODE   = "USD"

      def process
        @book = Spreadsheet.open(@file_path)

        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          unless row[TITLE].blank?
            book = find_or_create_book(row[TITLE])
            create_sale(book, :units => row[UNIT_NET_SALES], 
                              :date_of_sale => convert_date(row[DATE_OF_SALE]), 
                              :amount => row[REVENUE].to_money.cents, 
                              :currency => CURRENCY_CODE)
          end
        end
      end

      private

      def convert_date(date)
        DateTime.strptime(date, '%m/%d/%Y')
      end
    end
  end
end


