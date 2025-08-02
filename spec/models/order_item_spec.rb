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

RSpec.describe OrderItem, type: :model do
  let(:order_item) { create(:order_item) }


  context "validations" do
    it "returns valid when correct attributes passed" do
      expect(order_item).to be_valid
    end

    it "returns invalid when discount_price is < 0" do
      order_item.discount_price = -1
      expect(order_item).to be_invalid
    end

    it "returns invalid when total_price is < 0" do
      order_item.total_price = -1
      expect(order_item).to be_invalid
    end

    it "returns Order when .order is invoked" do
      expect(order_item.order).to be_a(Order)
    end

    it "returns Product when .order is invoked" do
      expect(order_item.product).to be_a(Product)
    end
  end
end
