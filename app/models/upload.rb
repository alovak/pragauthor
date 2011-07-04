class Upload < ActiveRecord::Base
  belongs_to :user

  attr_accessible :report
  mount_uploader :report, ReportUploader

  after_save :process_report

  private
  def process_report
    parser = Indie::Parser::BarnesNoble.new(report.current_path)
    parser.process
  end
end
