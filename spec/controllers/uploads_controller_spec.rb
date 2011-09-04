require 'spec_helper'

describe UploadsController do
  before do
    sign_in user
  end

  let(:user) { Factory(:confirmed_user) }

  def post_file
    post :create, :upload => { :file => "#{Rails.root}/features/support/files/kdp-report-04-2011.xls" }
  end

  describe "POST 'create'" do
    it "should create upload" do
      expect { post_file }.to change { user.uploads.count }.from(0).to(1)
    end

    context "when the upload saved successfully" do 

      it "sets a flash[:notice] message" do
        post_file

        flash[:notice].should == "You file was uploaded and processed"
      end

      it "redirects to the home" do
        post_file

        response.should redirect_to(home_path)
      end
    end

    context "when the upload was not saved successfully" do 

      it "should show proper explanation of the processing or uploading error" do
        pending
        
        post :create

        flash[:alert].should == "You file was not uploaded and processed"
      end

      it "redirects to the home" do
        post_file

        response.should redirect_to(home_path)
      end
    end
  end
end
