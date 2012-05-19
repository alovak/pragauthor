class Account < ActiveRecord::Base
  has_many :account_books
  has_many :books, :through => :account_books
  belongs_to :user

  attr_encrypted :login,    :key => '2252b9094e', :encode => true
  attr_encrypted :password, :key => '3c9242b27adc6', :encode => true

  validates_presence_of :login, :password

  def self.factory(name, *args)
    "Account::#{name}".constantize.new(*args)
  end

  def name
    self.class.name.demodulize
  end
end
