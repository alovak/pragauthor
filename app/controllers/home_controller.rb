class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @books = Book.all
  end
end
