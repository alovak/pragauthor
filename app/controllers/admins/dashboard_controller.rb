class Admins::DashboardController < ApplicationController
  layout 'admin'

  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  def index
  end
end
