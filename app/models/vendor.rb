class Vendor < ActiveRecord::Base
  has_many :books
  has_many :sales

  default_scope order('name')

  alias_attribute :title, :name

  def self.import
    ['Barnes&Noble', 'Amazon', 'Smashwords', 'CreateSpace', 'LeanPub'].each do |name|
      Vendor.find_or_create_by_name(name)
    end
  end
end
