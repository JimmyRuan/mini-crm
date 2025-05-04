require 'rails_helper'

RSpec.describe TagSerializer, type: :serializer do
  let(:tag) { create(:tag) }

  describe 'attributes' do
    it 'includes the expected attributes' do
      serializer = described_class.new(tag)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json.keys).to contain_exactly('id', 'name', 'created_at', 'updated_at', 'contacts')
    end

    it 'includes the correct values' do
      serializer = described_class.new(tag)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['id']).to eq(tag.id)
      expect(parsed_json['name']).to eq(tag.name)
      expect(parsed_json['created_at']).to eq(tag.created_at.as_json)
      expect(parsed_json['updated_at']).to eq(tag.updated_at.as_json)
    end
  end

  describe 'associations' do
    let(:first_contact) { create(:contact) }
    let(:second_contact) { create(:contact) }

    before do
      tag.contacts << [first_contact, second_contact]
    end

    it 'includes associated contacts' do
      serializer = described_class.new(tag)
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      serialized_json = serialization.to_json
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['contacts'].length).to eq(2)
      expect(parsed_json['contacts'].first['id']).to eq(first_contact.id)
      expect(parsed_json['contacts'].first['name']).to eq(first_contact.name)
      expect(parsed_json['contacts'].first['email']).to eq(first_contact.email)
    end
  end
end
