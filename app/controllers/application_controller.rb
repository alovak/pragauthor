class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || home_path
  end
end
