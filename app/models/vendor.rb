class Vendor < ActiveRecord::Base
  has_many :books
  has_many :sales
end
