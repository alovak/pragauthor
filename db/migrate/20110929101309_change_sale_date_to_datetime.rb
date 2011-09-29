class ChangeSaleDateToDatetime < ActiveRecord::Migration
  def change
    change_column :sales, :date_of_sale, :datetime
  end
end
