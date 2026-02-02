class Client < ApplicationRecord
  belongs_to :account
  belongs_to :user
  has_many :bookings, dependent: :destroy

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :account, presence: true
end
