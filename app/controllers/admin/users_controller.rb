class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy reset_password]

  def index
    @users = User.includes(:account).order(created_at: :desc)
  end

  def new
    @user = User.new
    @accounts = Account.active.order(:name)
  end

  def edit
    @accounts = Account.order(:name)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      @accounts = Account.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Don't require password on update unless it's being changed
    if user_params[:password].blank?
      params_without_password = user_params.except(:password, :password_confirmation)
      success = @user.update(params_without_password)
    else
      success = @user.update(user_params)
    end

    if success
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      @accounts = Account.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  def reset_password
    # Generate a temporary password
    temp_password = SecureRandom.alphanumeric(12)

    if @user.update(password: temp_password, password_confirmation: temp_password)
      flash[:notice] = "Password reset successfully. New temporary password: #{temp_password}"
      redirect_to admin_users_path
    else
      flash[:alert] = "Failed to reset password."
      redirect_to admin_users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :account_id)
  end
end
