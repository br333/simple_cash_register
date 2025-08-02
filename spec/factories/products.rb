FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 10) }
    price { Faker::Commerce.price(range: 100..1000) }
  end
end
