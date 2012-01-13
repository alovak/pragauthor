class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.database_authenticatable
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :admins, :email, :unique => true
  end
end
