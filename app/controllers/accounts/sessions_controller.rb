class Accounts::SessionsController < ApplicationController
  layout 'accounts'

  before_action :set_account_from_slug, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: :create

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase, account_id: @account.id)

    if user && !user.admin? && user.authenticate(params[:password])
      if @account.active?
        session[:user_id] = user.id
        redirect_to account_dashboard_path(account_slug: @account.slug), notice: "Logged in successfully!"
      else
        flash.now[:alert] = "Your account is inactive. Please contact support."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    account_slug = current_user&.account&.slug
    session[:user_id] = nil
    if account_slug
      redirect_to account_login_path(account_slug: account_slug), notice: "Logged out successfully!"
    else
      redirect_to root_path, notice: "Logged out successfully!"
    end
  end

  private

  def set_account_from_slug
    @account = Account.find_by!(slug: params[:account_slug])
  end
end
