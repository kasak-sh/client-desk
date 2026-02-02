class Admin::AccountsController < Admin::BaseController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @accounts = Account.order(created_at: :desc)
  end

  def show
    @users = @account.users.order(:name)
    @clients = @account.clients.order(created_at: :desc).limit(10)
    @bookings = @account.bookings.order(scheduled_at: :desc).limit(10)
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to admin_account_path(@account), notice: 'Account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      redirect_to admin_account_path(@account), notice: 'Account was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy!
    redirect_to admin_accounts_path, notice: 'Account was successfully deleted.'
  end

  private

  def set_account
    @account = Account.find_by!(slug: params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :slug, :status, :logo)
  end
end
