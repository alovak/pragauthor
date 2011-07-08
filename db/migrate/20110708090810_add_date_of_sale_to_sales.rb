class AddDateOfSaleToSales < ActiveRecord::Migration
  def change
    add_column :sales, :date_of_sale, :date
  end
end
