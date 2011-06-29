require 'spec_helper'

describe HomeController do
  describe "GET index" do
    before { sign_in Factory.create(:confirmed_user) }

    it "should assign @books" do
      books = mock
      Book.should_receive(:all).and_return(books)

      get :index

      assigns(:books).should eq(books)
    end
  end
end
