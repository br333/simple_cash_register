# == Schema Information
#
# Table name: order_items
#
#  id             :integer          not null, primary key
#  discount_price :decimal(10, 2)   default(0.0), not null
#  quantity       :integer
#  subtotal       :decimal(10, 2)   default(0.0), not null
#  total_price    :decimal(10, 2)   default(0.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :integer          not null
#  product_id     :integer          not null
#  promotion_id   :integer
#
# Indexes
#
#  index_order_items_on_order_id      (order_id)
#  index_order_items_on_product_id    (product_id)
#  index_order_items_on_promotion_id  (promotion_id)
#
# Foreign Keys
#
#  order_id      (order_id => orders.id)
#  product_id    (product_id => products.id)
#  promotion_id  (promotion_id => promotions.id)
#
FactoryBot.define do
  factory :order_item do
    total_price { Faker::Commerce.price(range: 10..1000) }
    discount_price { Faker::Commerce.price(range: 100..1000) }
    quantity { rand(1..10) }

    association :order
    association :product, factory: [ :product, :with_promotion ]

    after(:build) do |order_item|
      order_item.promotion ||= order_item.product.promotion
    end
  end
end
