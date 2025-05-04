FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }

    trait :with_tags do
      transient do
        tags_count { 2 }
      end

      after(:create) do |contact, evaluator|
        tags = create_list(:tag, evaluator.tags_count)
        tags.each do |tag|
          create(:contact_tag, contact: contact, tag: tag)
        end
      end
    end
  end
end 