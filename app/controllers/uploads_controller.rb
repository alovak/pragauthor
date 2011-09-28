class UploadsController < ApplicationController
  def create
    upload = current_user.uploads.build
    upload.attributes = params[:upload]

    if upload.save
      flash[:notice] = "You file was uploaded and processed"
      redirect_to home_path
    else
      flash[:alert] = "Unfortunately, we can't process your file" 
      redirect_to home_path
    end
  end

end
