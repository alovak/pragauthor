class AddEncryptedAttributesToAccount < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.rename :login, :encrypted_login
      t.rename :password, :encrypted_password
    end
  end
end
