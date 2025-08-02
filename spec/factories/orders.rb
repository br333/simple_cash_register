# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  subtotal    :decimal(10, 2)   default(0.0), not null
#  total_price :decimal(10, 2)   default(0.0), not null
#  uuid        :string           default("gen_random_uuid()"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_uuid  (uuid) UNIQUE
#
FactoryBot.define do
  factory :order do
    uuid { Faker::Internet.uuid }
    total_price { Faker::Commerce.price(range: 10..1000) }
    subtotal { Faker::Commerce.price(range: 100..1000) }
    trait :with_items do
      after(:create) do |order|
        create_list(:order_item, 3, order: order)
      end
    end
  end
end
