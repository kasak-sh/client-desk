class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :scheduled_at, null: false
      t.integer :duration_minutes
      t.string :status, null: false, default: 'pending'
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bookings, :scheduled_at
  end
end
