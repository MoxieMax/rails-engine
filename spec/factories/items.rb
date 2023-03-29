FactoryBot.define do
  factory :item do
    name { Faker::JapaneseMedia::CowboyBebop.character }
    # description { Faker::Lorem.paragraph(sentence_count: 2) }
    description { Faker::JapaneseMedia::CowboyBebop.quote }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    # merchant { nil }
  end
end