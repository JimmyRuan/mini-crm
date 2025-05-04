require 'rails_helper'

RSpec.describe ContactSerializer, type: :serializer do
  let(:contact) { create(:contact) }

  describe 'attributes' do
    it 'includes the expected attributes' do
      serializer = described_class.new(contact)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json.keys).to contain_exactly('id', 'name', 'email', 'created_at', 'updated_at', 'tags')
    end

    it 'includes the correct values' do
      serializer = described_class.new(contact)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['id']).to eq(contact.id)
      expect(parsed_json['name']).to eq(contact.name)
      expect(parsed_json['email']).to eq(contact.email)
      expect(parsed_json['created_at']).to eq(contact.created_at.as_json)
      expect(parsed_json['updated_at']).to eq(contact.updated_at.as_json)
    end
  end

  describe 'associations' do
    let(:first_tag) { create(:tag) }
    let(:second_tag) { create(:tag) }

    before do
      contact.tags << [first_tag, second_tag]
    end

    it 'includes associated tags' do
      serializer = described_class.new(contact)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['tags'].length).to eq(2)
      expect(parsed_json['tags'].first['id']).to eq(first_tag.id)
      expect(parsed_json['tags'].first['name']).to eq(first_tag.name)
    end
  end
end
