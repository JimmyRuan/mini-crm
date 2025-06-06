class ContactTag < ApplicationRecord
  # Validations
  validates :contact_id, uniqueness: { scope: :tag_id }

  # Associations
  belongs_to :contact
  belongs_to :tag
end
