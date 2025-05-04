require 'rails_helper'

RSpec.describe Tag do
  describe 'validations' do
    subject { build(:tag) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:contact_tags).dependent(:destroy) }
    it { is_expected.to have_many(:contacts).through(:contact_tags) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:tag)).to be_valid
    end

    it 'creates a tag with a unique name' do
      existing_tag = create(:tag)
      new_tag = build(:tag, name: existing_tag.name)
      expect(new_tag).not_to be_valid
      expect(new_tag.errors[:name]).to include('has already been taken')
    end
  end
end
