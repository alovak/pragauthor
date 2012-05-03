class CreateAccountBooks < ActiveRecord::Migration
  def change
    create_table :account_books do |t|
      t.references :account
      t.references :book
      t.string :lean_pub_link

      t.timestamps
    end
  end
end
