class VendorsController < ApplicationController
  helper :chart

  def index
    @books = current_user.books
    @sales = current_user.sales
  end
end

