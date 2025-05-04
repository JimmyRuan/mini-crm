class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at
  has_many :tags, serializer: TagSerializer

  def tags
    object.tags
  end
end 