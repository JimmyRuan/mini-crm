class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  has_many :contacts, serializer: ContactSerializer

  def contacts
    object.contacts
  end
end 