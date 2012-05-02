module Indie
  module Parser
    class CreateSpace < Base

      VENDOR_NAME = 'CreateSpace'
      SKIP_ROWS   = 6
      
      START_DATE  = 1
      END_DATE    = 1

      attr_reader :title_column, :unit_net_sales_column, :date_of_sale_column, :revenue_column

      def process
        @book = Spreadsheet.open(@file_path)

        sheet = @book.worksheet 0

        set_columns(sheet)
        delete_existed_sales_for_period(sheet)

        sheet.each(SKIP_ROWS) do |row|
          unless row[title_column].blank?
            book = find_or_create_book(row[title_column])
            book.sales.create(:vendor => vendor,
                              :units => row[unit_net_sales_column], 
                              :date_of_sale => convert_date(row[date_of_sale_column]), 
                              :amount => row[revenue_column].to_money.cents, 
                              :currency => row[revenue_column].to_money.currency.iso_code)
          end
        end
      end

      private

      def set_columns(sheet)
        header = sheet.row(5)
        @title_column = header.find_index "Title Name"
        @unit_net_sales_column = header.find_index "Quantity"
        @date_of_sale_column = header.find_index "Sale Date"
        @revenue_column = header.find_index "Royalty"
      end

      def delete_existed_sales_for_period(sheet)
        start_date = Chronic.parse(sheet.row(2)[START_DATE])
        end_date = Chronic.parse(sheet.row(3)[END_DATE])

        [].tap do |books|
          sheet.each(SKIP_ROWS) do |row|
            unless row[title_column].blank?
              books << find_or_create_book(row[title_column])
            end
          end

          books.uniq.each do |book| 
            book
              .sales
              .where(:vendor_id => vendor.id, :date_of_sale => (start_date..end_date))
              .delete_all
          end
        end
      end

      def convert_date(date)
        date
      end
    end
  end
end


