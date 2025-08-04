# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string
#  price       :decimal(10, 2)   default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 10) }
    price { Faker::Commerce.price(range: 100..1000) }

    trait :with_promotion do
      after(:create) do |product|
        create(:promotion, :with_rule, product: product)
      end
    end

    trait :green_tea do
      after(:build) do |product|
        product.name = 'Green Tea'
        product.price = 3.11
      end
      after(:create) do |product|
        create(:promotion, :with_rule_fixed, product: product)
      end
    end

    trait :strawberry do
      after(:build) do |product|
        product.name = 'Strawberry'
        product.price = 5.0
      end
      after(:create) do |product|
        create(:promotion, :with_rule_bundle_strawberry, product: product)
      end
    end

    trait :coffee do
      after(:build) do |product|
        product.name = 'Coffee'
        product.price = 11.23
      end
      after(:create) do |product|
        create(:promotion, :with_rule_bundle_coffee, product: product)
      end
    end
  end
end
