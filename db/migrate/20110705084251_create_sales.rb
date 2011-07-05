class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :book_id
      t.integer :units

      t.timestamps
    end
  end
end
