class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password
      t.string :type

      t.references :user_id

      t.timestamps
    end
  end
end
