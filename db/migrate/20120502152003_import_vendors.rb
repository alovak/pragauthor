class ImportVendors < ActiveRecord::Migration
  def up
    Vendor.import
  end
end
