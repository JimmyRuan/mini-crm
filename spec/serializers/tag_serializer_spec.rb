require 'rails_helper'

RSpec.describe TagSerializer, type: :serializer do
  let(:tag) { create(:tag) }
  let(:serializer) { described_class.new(tag) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_json) { serialization.to_json }

  describe 'attributes' do
    it 'includes the expected attributes' do
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json.keys).to contain_exactly('id', 'name', 'created_at', 'updated_at', 'contacts')
    end

    it 'includes the correct values' do
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['id']).to eq(tag.id)
      expect(parsed_json['name']).to eq(tag.name)
      expect(parsed_json['created_at']).to eq(tag.created_at.as_json)
      expect(parsed_json['updated_at']).to eq(tag.updated_at.as_json)
    end
  end

  describe 'associations' do
    let!(:contact1) { create(:contact) }
    let!(:contact2) { create(:contact) }
    
    before do
      tag.contacts << [contact1, contact2]
    end

    it 'includes associated contacts' do
      parsed_json = JSON.parse(serialized_json)
      expect(parsed_json['contacts'].length).to eq(2)
      expect(parsed_json['contacts'].first['id']).to eq(contact1.id)
      expect(parsed_json['contacts'].first['name']).to eq(contact1.name)
      expect(parsed_json['contacts'].first['email']).to eq(contact1.email)
    end
  end
end 