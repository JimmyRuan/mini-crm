require 'rails_helper'
include FactoryBot::Syntax::Methods

RSpec.describe Contact, type: :model do
  describe 'validations' do
    let(:contact) { build(:contact) }
    let!(:existing_contact) { create(:contact) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message('has already been taken') }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:contact_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:contact_tags) }
  end

  describe 'scopes' do
    let!(:tag1) { create(:tag, name: 'VIP') }
    let!(:tag2) { create(:tag, name: 'Regular') }
    let!(:contact1) { create(:contact) }
    let!(:contact2) { create(:contact) }

    before do
      create(:contact_tag, contact: contact1, tag: tag1)
      create(:contact_tag, contact: contact2, tag: tag2)
    end

    describe '.with_tag' do
      it 'returns contacts with the specified tag' do
        expect(Contact.with_tag('VIP')).to include(contact1)
        expect(Contact.with_tag('VIP')).not_to include(contact2)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:contact)).to be_valid
    end

    it 'creates a contact with tags when using :with_tags trait' do
      contact = create(:contact, :with_tags, tags_count: 3)
      expect(contact.tags.count).to eq(3)
    end
  end
end
