module Indie
  module Parser
    class Amazon < Base

      TITLE         = 0
      UNIT_NET_SALES = 4
      BOOKS_OFFSET   = 4
      SALE_DATE_OFFSET = 2

      def process
        @book = Spreadsheet.open(@file_path)
        sheet = @book.worksheet 0
        sheet.each do |row|
          process_books_for_store(sheet, row.idx) if row[0] == 'Title'
        end
      end

      private

      def process_books_for_store(sheet, header_row_id)
        return if sheet.row(header_row_id + BOOKS_OFFSET)[0] == 'There were no sales during this period.'

        sale_date = convert_date(sheet.row(header_row_id + SALE_DATE_OFFSET)[0])

        sheet.each(header_row_id + BOOKS_OFFSET) do |row|
          return if row[TITLE] =~ /Total Royalty for Sales/
          book = Book.find_or_create_by_title(row[TITLE])
          book.sales.create(:units => row[UNIT_NET_SALES], :vendor => vendor, :date_of_sale => sale_date)
        end
      end

      def vendor
        @vendor ||= Vendor.find_by_name('Amazon')
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
