class Accounts::DashboardController < Accounts::BaseController
  def index
    @total_clients = current_account.clients.count
    @total_bookings = current_account.bookings.count
    @upcoming_bookings = current_account.bookings.upcoming.where('scheduled_at <= ?', 7.days.from_now).limit(5)
    @recent_clients = current_account.clients.order(created_at: :desc).limit(5)
  end
end
