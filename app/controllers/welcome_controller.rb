class WelcomeController < ApplicationController
  layout 'welcome'

  skip_before_filter :authenticate_user!

  def index
  end

  def about
  end

  def contact
  end

  def exception_2211
    raise "Hello"
  end
end
