require 'spec_helper'

describe UploadsController do

  describe "POST 'create'" do
    let(:upload) { mock_model(Upload, :save => nil) }

    before do
      Upload.stub(:new).and_return(upload)
    end

    it "should create upload" do
      Upload.should_receive(:new).with('file' => 'file name').and_return(upload)

      post :create, :upload => { :file => 'file name' }
    end

    it "should save message" do
      upload.should_receive(:save)

      post :create
    end

    context "when the upload saved successfully" do 
      before(:each) do
        upload.stub(:save).and_return(true) 
      end

      it "sets a flash[:notice] message" do
        post :create

        flash[:notice].should == "You file was uploaded and processed"
      end

      it "redirects to the home" do
        post :create

        response.should redirect_to(home_path)
      end
    end

    context "when the upload was not saved successfully" do 
      before(:each) do
        upload.stub(:save).and_return(false) 
      end

      it "should show proper explanation of the processing or uploading error"

      it "sets a flash[:alert] message" do
        post :create

        flash[:alert].should == "You file was not uploaded and processed"
      end

      it "redirects to the home" do
        post :create

        response.should redirect_to(home_path)
      end
    end
  end

end
