class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at
  has_many :tags, serializer: TagSerializer

  delegate :tags, to: :object
end
