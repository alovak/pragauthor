class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :rememberable

  attr_accessible :email, :password, :password_confirmation, :remember_me
end
