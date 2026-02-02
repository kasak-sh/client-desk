class Account < ApplicationRecord
  attribute :status, :string
  enum status: { active: 'active', inactive: 'inactive' }

  has_one_attached :logo
  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :status, presence: true

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present?
    base_slug = name.parameterize
    slug_candidate = base_slug
    counter = 1

    while Account.exists?(slug: slug_candidate)
      slug_candidate = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = slug_candidate
  end
end
