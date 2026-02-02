class Accounts::BaseController < ApplicationController
  layout 'accounts'

  before_action :set_account_from_slug
  before_action :require_login
  before_action :require_regular_user
  before_action :require_active_account
  before_action :verify_account_access

  helper_method :current_account

  private

  def set_account_from_slug
    @account = Account.find_by!(slug: params[:account_slug])
  end

  def current_account
    @account
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to account_login_path(account_slug: @account.slug)
    end
  end

  def verify_account_access
    unless current_user.account_id == @account.id
      flash[:alert] = "You don't have access to this account"
      redirect_to account_dashboard_path(account_slug: current_user.account.slug)
    end
  end
end
