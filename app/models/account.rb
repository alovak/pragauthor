class Account < ActiveRecord::Base
  has_many :account_books
  has_many :books, :through => :account_books
end
