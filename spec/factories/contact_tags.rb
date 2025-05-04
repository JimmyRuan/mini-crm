FactoryBot.define do
  factory :contact_tag do
    association :contact
    association :tag
  end
end 