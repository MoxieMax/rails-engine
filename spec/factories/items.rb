FactoryBot.define do
  factory :item do
    name { Faker::Games::DnD.monster }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    # merchant { nil }
  end
end
