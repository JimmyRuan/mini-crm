require 'rails_helper'

RSpec.describe ContactTag do
  describe 'validations' do
    let(:contact) { create(:contact) }
    let(:tag) { create(:tag) }
    let(:contact_tag) { create(:contact_tag, contact: contact, tag: tag) }

    it 'validates uniqueness of contact_id scoped to tag_id' do
      create(:contact_tag, contact: contact, tag: tag)
      new_contact_tag = build(:contact_tag, contact: contact, tag: tag)
      expect(new_contact_tag).not_to be_valid
      expect(new_contact_tag.errors[:contact_id]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contact) }
    it { is_expected.to belong_to(:tag) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      contact = create(:contact)
      tag = create(:tag)
      expect(build(:contact_tag, contact: contact, tag: tag)).to be_valid
    end

    it 'creates a unique contact-tag combination' do
      contact_tag = create(:contact_tag)
      duplicate = build(:contact_tag, contact: contact_tag.contact, tag: contact_tag.tag)
      expect(duplicate).not_to be_valid
    end
  end
end
