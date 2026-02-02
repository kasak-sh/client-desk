class Booking < ApplicationRecord
  belongs_to :account
  belongs_to :client
  belongs_to :user

  attribute :status, :string
  enum status: { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' }

  validates :title, presence: true
  validates :scheduled_at, presence: true
  validates :status, presence: true
  validates :account, presence: true

  scope :upcoming, -> { where('scheduled_at >= ?', Time.current).order(scheduled_at: :asc) }
  scope :recent, -> { order(created_at: :desc) }
end
