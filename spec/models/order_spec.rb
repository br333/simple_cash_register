# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  subtotal    :decimal(10, 2)   default(0.0), not null
#  total_price :decimal(10, 2)   default(0.0), not null
#  uuid        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_uuid  (uuid) UNIQUE
#
RSpec.describe Order, type: :model do
  let(:order) { create(:order) }

  context "validations" do
    it "returns valid when correct attributes passed" do
      expect(order).to be_valid
    end

    it "returns invalid when subtotal is < 0" do
      order.subtotal = -1
      expect(order).to be_invalid
    end

    it "returns invalid when total_price is < 0" do
      order.total_price = -1
      expect(order).to be_invalid
    end

    it "returns array of OrderItem" do
      expect(order.order_items).to be_a(ActiveRecord::Associations::CollectionProxy)
    end

    context "validates uuid" do
      let(:duplicate_order) { create(:order, uuid: "12345678") }

      it "generates uuid if uuid is blank" do
        order.uuid = nil
        expect(order).to be_valid
        expect(order.uuid).to_not be_nil
      end

      it "is valid with a uuid" do
        order.uuid = "12345678"
        expect(order).to be_valid
      end

      it "generates uuid if uuid is duplicate" do
        order.uuid = duplicate_order.uuid
        expect(order).to be_valid
        expect(order.uuid).to_not be_nil
        expect(order.uuid).to_not eq(duplicate_order.uuid)
      end

      it "generates uuid if uuid is nil" do
        order.uuid = nil
        expect(order).to be_valid
        expect(order.uuid).to_not be_nil
        expect(order.uuid).to_not eq(duplicate_order.uuid)
      end
    end
  end
end
