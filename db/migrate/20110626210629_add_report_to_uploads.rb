class AddReportToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :report, :string
  end
end
