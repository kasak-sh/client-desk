class Accounts::ClientsController < Accounts::BaseController
  before_action :set_client, only: %i[ show edit update destroy ]

  def index
    @clients = current_account.clients.order(created_at: :desc)
  end

  def show
  end

  def new
    @client = current_account.clients.build
  end

  def edit
  end

  def create
    @client = current_account.clients.build(client_params)
    @client.user = current_user

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_path(account_slug: current_account.slug, id: @client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_path(account_slug: current_account.slug, id: @client), notice: "Client was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy!

    respond_to do |format|
      format.html { redirect_to clients_path(account_slug: current_account.slug), notice: "Client was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_client
    @client = current_account.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :phone, :company, :notes)
  end
end
