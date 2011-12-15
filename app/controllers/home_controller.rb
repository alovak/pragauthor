class HomeController < ApplicationController

  def index
    @books = current_user.books
    @sales = current_user.sales
  end
end
