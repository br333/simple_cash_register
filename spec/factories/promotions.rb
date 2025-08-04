# == Schema Information
#
# Table name: promotions
#
#  id         :integer          not null, primary key
#  active     :boolean
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :integer
#
# Indexes
#
#  index_promotions_on_product_id  (product_id)
#
# Foreign Keys
#
#  product_id  (product_id => products.id)
#
FactoryBot.define do
  factory :promotion do
    name { Faker::Commerce.product_name }
    code { Faker::Commerce.promotion_code }
    active { true }
    association :product
    trait :with_rule do
      after(:create) do |promotion|
        create(:promotion_rule, promotion: promotion)
      end
    end
    trait :with_rule_fixed do
      after(:create) do |promotion|
        create(:promotion_rule, rule_type: 'fix', discount: 50, promotion: promotion)
      end
    end
    trait :with_rule_bundle_strawberry do
      after(:create) do |promotion|
        create(:promotion_rule, rule_type: 'bundle', discount: 10, required_items_count: 3, promotion: promotion)
      end
    end
    trait :with_rule_bundle_coffee do
      after(:create) do |promotion|
        create(:promotion_rule, rule_type: 'bundle', discount: 33.33, required_items_count: 3, promotion: promotion)
      end
    end
  end
end
