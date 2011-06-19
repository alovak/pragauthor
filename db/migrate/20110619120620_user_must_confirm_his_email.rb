class UserMustConfirmHisEmail < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.confirmable
    end
  end

  def down
    change_table :users do |t|
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
    end
  end
end
