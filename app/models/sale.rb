class Sale < ActiveRecord::Base
  belongs_to :book
  belongs_to :vendor


  scope :for_vendor, lambda { |name| where("vendor_id == ?", Vendor.find_by_name(name)) }
end
