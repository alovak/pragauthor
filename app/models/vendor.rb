class Vendor < ActiveRecord::Base
  has_many :books
  has_many :sales

  default_scope order('name')

  alias_attribute :title, :name
end
