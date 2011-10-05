require 'spec_helper'

describe UploadsController do
  before do
    sign_in user
  end

  let(:user) { Factory(:confirmed_user) }
  let(:file) { "#{Rails.root}/features/support/files/kdp-report-04-2011.xls" }

  def post_file(file_name = nil)
    file_name ||= file
    post :create, :upload => { :report => Rack::Test::UploadedFile.new(file_name, "application/vnd.ms-excel") }
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

    
    context "when the upload is invalid" do 
      before { post_file("#{Rails.root}/features/support/files/unknown.txt")}

      it "should render :new" do
        response.should render_template :new
      end

      it "should assign @upload" do
        assigns(:upload).should be_a_new(Upload)
      end
    end
  end
end
