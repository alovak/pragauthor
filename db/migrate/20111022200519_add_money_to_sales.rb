class AddMoneyToSales < ActiveRecord::Migration
  def change
    add_column :sales, :amount, :integer
    add_column :sales, :currency, :string, :limit => 3
  end
end
