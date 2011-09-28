class WelcomeController < ApplicationController
  layout 'welcome'

  skip_before_filter :authenticate_user!

  def index
  end

  def exception_2211
    raise "Hello"
  end
end
