class Upload < ActiveRecord::Base
  belongs_to :user

  attr_accessible :report
  mount_uploader :report, ReportUploader

  validates_presence_of :report
end
