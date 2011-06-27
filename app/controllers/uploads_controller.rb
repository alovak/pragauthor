class UploadsController < ApplicationController
  def create
    upload = Upload.new(params[:upload])

    if upload.save
      flash[:notice] = "You file was uploaded and processed"
      redirect_to home_path
    else
      flash[:alert] = "You file was not uploaded and processed" 
      redirect_to home_path
    end
  end

end
