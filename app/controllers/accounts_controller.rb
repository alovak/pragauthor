class AccountsController < ApplicationController
  inherit_resources

  before_filter :set_resource, :only => [:new, :create]

  actions :all, :except => [:show]

  private

  def set_resource
    @account = Account.factory(params[:account].delete(:name), params[:account])
    @account.user = current_user
  end

  protected

  def begin_of_association_chain
    current_user
  end
end
