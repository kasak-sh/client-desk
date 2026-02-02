class WelcomeController < ApplicationController
  def index
    if logged_in?
      if current_user.admin?
        redirect_to admin_accounts_path
      else
        redirect_to account_dashboard_path(account_slug: current_user.account.slug)
      end
    end
  end
end
