class UploadsController < ApplicationController
  def index
    @uploads = current_user.uploads
  end

  def new
    @upload = current_user.uploads.build
  end

  def create
    @upload = current_user.uploads.build
    @upload.attributes = params[:upload]

    if @upload.save
      flash[:notice] = "You file was uploaded and processed"
      redirect_to home_path
    else
      render :new
    end
  end

end
