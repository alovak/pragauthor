module Indie
  module Parser
    class BarnesNoble < Base

      VENDOR_NAME     = 'Barnes&Noble'
      SKIP_ROWS       = 1

      CURRENCY_CODE   = "USD"

      attr_reader :title_column, :unit_net_sales_column, :date_of_sale_column, :revenue_column

      def process
        @book = Spreadsheet.open(@file_path)

        set_columns

        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          unless row[title_column].blank?
            book = find_or_create_book(row[title_column])
            create_sale(book, :units => row[unit_net_sales_column], 
                              :date_of_sale => convert_date(row[date_of_sale_column]), 
                              :amount => row[revenue_column].to_money.cents, 
                              :currency => CURRENCY_CODE)
          end
        end
      end

      private

      def set_columns
        header = @book.worksheet(0).row(0)
        @title_column = header.find_index "Title"
        @unit_net_sales_column = header.find_index "Net Unit Sales"
        @date_of_sale_column = header.find_index "Date Of Sale"
        @revenue_column = header.find_index "Total Publisher's Revenue"
      end

      def convert_date(date)
        DateTime.strptime(date, '%m/%d/%Y')
      end
    end
  end
end


