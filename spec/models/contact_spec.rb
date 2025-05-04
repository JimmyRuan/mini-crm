require 'rails_helper'

RSpec.describe Contact do
  include FactoryBot::Syntax::Methods

  describe 'validations' do
    subject { build(:contact, name: 'Test Contact', email: 'test@example.com') }

    let(:contact_with_same_email) { create(:contact, name: 'Existing Contact', email: 'test@example.com') }

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
    let(:vip_tag) { create(:tag, name: 'VIP') }
    let(:regular_tag) { create(:tag, name: 'Regular') }
    let(:vip_contact) { create(:contact) }
    let(:regular_contact) { create(:contact) }

    before do
      create(:contact_tag, contact: vip_contact, tag: vip_tag)
      create(:contact_tag, contact: regular_contact, tag: regular_tag)
    end

    describe '.with_tag' do
      it 'returns contacts with the specified tag' do
        expect(described_class.with_tag('VIP')).to include(vip_contact)
        expect(described_class.with_tag('VIP')).not_to include(regular_contact)
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
