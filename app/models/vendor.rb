class Vendor < ActiveRecord::Base
  has_many :books
  has_many :sales

  default_scope order('name')
end
