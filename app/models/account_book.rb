class AccountBook < ActiveRecord::Base
  belongs_to :account
  belongs_to :book

  has_many :sales, :through => :book
end
