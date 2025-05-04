class Tag < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Associations
  has_many :contact_tags, dependent: :destroy
  has_many :contacts, through: :contact_tags
end
