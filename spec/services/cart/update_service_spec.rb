require 'pry-byebug'
RSpec.describe Cart::UpdateService, type: :service do
  subject(:service) { described_class.call(product_id: product_id, quantity: quantity, order_id: order_id) }
  let(:product) { create(:product, :with_promotion) }
  let(:order) { create(:order) }
  let(:quantity) { rand(1..20) }
  let(:order_id) { order.id }
  let(:product_id) { product.id }


  context "#call" do
    it "returns no error when parameters are valid" do
      expect {
        subject
      }.to_not raise_error
    end

    context "when invalid parameters passed" do
      let(:product_id) { nil }
      let(:quantity) { nil }
      let(:order_id) { nil }
      it "returns error when invalid parameters are passed" do
        expect {
          subject
        }.to raise_error(Cart::BaseService::CartValidationError)
      end
    end

    it "adds an item to the order" do
      expect {
        subject
      }.to change(OrderItem, :count).by(1)
    end

    context "when quantity is invalid" do
      let(:quantity) { -1 }
      it "raises an error" do
        expect {
          subject
        }.to raise_error(Cart::BaseService::CartValidationError)
      end
    end

    it "returns Order" do
      expect(subject).to eq(order)
    end


    context "when there's an existing order" do
      let(:order_multiple) { create(:order, :with_items) }
      let(:order_id) { order_multiple.id }
      let(:order_items) { order_multiple.order_items }
      let(:selected_order_item) { order_items.sample }

      let(:product_id) { selected_order_item.product.id }
      let(:quantity) { 100 }
      it "updates OrderItem" do
        expect {
          subject
        }.to_not change(order_items, :count)

        expect(selected_order_item.reload.quantity).to eq(100)
      end
    end
  end
end
