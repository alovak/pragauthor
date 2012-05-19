class AddPurchaseItToSales < ActiveRecord::Migration
  def change
    add_column :sales, :purchase_id, :string
  end
end
