class AddAccountToBookings < ActiveRecord::Migration[7.2]
  def change
    add_reference :bookings, :account, null: false, foreign_key: true
  end
end
