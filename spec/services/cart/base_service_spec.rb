RSpec.describe Cart::BaseService, type: :service do
  subject(:service) { described_class.new(product_id: product_id, order_id: order_id, quantity: quantity) }
  let(:order) { create(:order) }
  let(:product) { create(:product) }
  let(:order_id) { nil }
  let(:quantity) { rand(1..9) }
  let(:product_id) { product.id }

  it "initializes" do
    expect(described_class).to respond_to(:new)
  end

  context "handles order validations" do
    it "returns array of error message" do
      subject.add_error("Error")
      expect(subject.errors).to include("Error")
      expect(subject).to respond_to(:valid?)
      expect(subject.valid?).to eq(false)
    end

    context "#order" do
      it "responds to .order" do
        expect(subject).to respond_to(:order)
      end

      context "when order is not found" do
        it "creates a new order and returns it" do
          expect { subject.order }.to change(Order, :count).by(1)
          expect(subject.order).not_to be_nil
        end
      end

      context "when order_id is present" do
        let(:order_id) { order.id }
        it "returns Order when @order_id is present" do
          expect(service.order).to eq(order)
        end
      end
    end

    context "#product" do
      it "responds to .product" do
        expect(subject).to respond_to(:product)
      end

      it "returns the product" do
        expect(subject.product).to eq(product)
      end

      context "when product is not found" do
        let(:product_id) { 999 }
        it "raises CartValidationError" do
          expect {
            subject.product
          }.to raise_error(Cart::BaseService::CartValidationError)
        end
      end

      context "when order_id is present" do
        let(:order_id) { order.id }
        it "returns Order" do
          expect(subject.order).to eq(order)
        end
      end
    end
  end
end
