class User < ApplicationRecord
  has_secure_password

  attribute :role, :string
  enum role: { user: 'user', admin: 'admin' }

  belongs_to :account, optional: true
  has_many :clients, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true
  validate :account_required_for_regular_users

  def admin?
    role == 'admin'
  end

  private

  def account_required_for_regular_users
    if role == 'user' && account_id.nil?
      errors.add(:account, "is required for regular users")
    end
  end
end
