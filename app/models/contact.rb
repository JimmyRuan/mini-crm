class Contact < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Associations
  has_many :contact_tags, dependent: :destroy
  has_many :tags, through: :contact_tags

  # Scopes
  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
end 