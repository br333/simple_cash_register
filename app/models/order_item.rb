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
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :promotion, optional: true
  validates :discount_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
