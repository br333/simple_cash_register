FactoryBot.define do
  factory :promotion do
    name { Faker::Commerce.product_name }
    code { Faker::Commerce.promotion_code }
    active { true }
  end
end
