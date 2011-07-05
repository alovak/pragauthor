class AddVendorToSale < ActiveRecord::Migration
  def change
    add_column :sales, :vendor_id, :integer
  end
end
