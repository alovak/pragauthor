class HomeController < ApplicationController

  def index
    @books = current_user.books.all
  end
end
