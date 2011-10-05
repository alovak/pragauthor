class Upload < ActiveRecord::Base
  belongs_to :user

  attr_accessible :report
  mount_uploader :report, ReportUploader

  default_scope order("created_at DESC")

  validates_presence_of :report
end
