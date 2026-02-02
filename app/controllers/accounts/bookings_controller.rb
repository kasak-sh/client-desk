class Accounts::BookingsController < Accounts::BaseController
  before_action :set_booking, only: %i[ show edit update destroy ]

  def index
    @bookings = current_account.bookings.includes(:client).order(scheduled_at: :desc)
  end

  def show
  end

  def new
    @booking = current_account.bookings.build
    @clients = current_account.clients.order(:name)
  end

  def edit
    @clients = current_account.clients.order(:name)
  end

  def create
    @booking = current_account.bookings.build(booking_params)
    @booking.user = current_user

    respond_to do |format|
      if @booking.save
        format.html { redirect_to booking_path(account_slug: current_account.slug, id: @booking), notice: "Booking was successfully created." }
        format.json { render :show, status: :created, location: @booking }
      else
        @clients = current_account.clients.order(:name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_path(account_slug: current_account.slug, id: @booking), notice: "Booking was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @booking }
      else
        @clients = current_account.clients.order(:name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to bookings_path(account_slug: current_account.slug), notice: "Booking was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_booking
    @booking = current_account.bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:title, :description, :scheduled_at, :duration_minutes, :status, :client_id)
  end
end
