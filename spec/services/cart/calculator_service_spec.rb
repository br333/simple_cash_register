RSpec.describe Cart::CalculatorService, type: :service do
  let(:order) { create(:order, :with_items) }
  let(:order_id) { order.id }
  subject(:service) { described_class.call(order_id: order_id) }

  context "#call" do
    it "returns no error when parameters are valid" do
      expect {
        subject
      }.to_not raise_error
    end

    context "when order is invalid" do
      let(:order_id) { nil }

      it "returns error when invalid parameters are passed" do
        expect {
          subject
        }.to raise_error(Cart::BaseService::CartValidationError)
      end
    end

    context "when order is valid" do
      it "recalculates order totals" do
        expect { subject }
          .to change { order.reload.subtotal }
          .and change { order.reload.total_price }
      end
    end

    context "when order_items are valid" do
      context "when promotion is fixed = b1g1 (green tea)" do
        let(:product)   { create(:product, :green_tea) }
        let(:order)     { create(:order) }
        let(:quantity)  { 2 }
        let(:order_item) { create(:order_item, order: order, quantity: quantity, product: product, promotion: product.promotion) }
        it "sets discount_price as b1g1" do
          expect {
           service
          }.to change { order_item.reload.discount_price }
          expect(order_item.discount_price).to eq(3.11)
        end

        context "regardless of quantity" do
          let(:quantity) { 5 }
          it "sets discount_price as b1g1" do
            expect {
             service
            }.to change { order_item.reload.discount_price }
            expect(order_item.discount_price).to eq(9.33)
          end
        end
      end

      context "when promotion is bundle (strawberry)" do
        let(:product)   { create(:product, :strawberry) }
        let(:order)     { create(:order) }
        let(:quantity)  { 3 }
        let(:order_item) { create(:order_item, order: order, quantity: quantity, product: product, promotion: product.promotion) }
        it "sets discount_price as bundle ruled with quantity set" do
          expect {
           service
          }.to change { order_item.reload.discount_price }
          expect(order_item.discount_price).to eq(13.5)
        end

        context "required_quantity does not match" do
          let(:quantity) { 2 }
          it "does not set discount price" do
            expect {
             service
            }.to change { order_item.reload.discount_price }
            expect(order_item.discount_price).to eq(10)
          end
        end
      end

      context "when promotion is bundle (coffee)" do
        let(:product)   { create(:product, :coffee) }
        let(:order)     { create(:order) }
        let(:quantity)  { 3 }
        let(:order_item) { create(:order_item, order: order, quantity: quantity, product: product, promotion: product.promotion) }
        it "sets discount_price as bundle ruled with quantity set" do
          expect {
           service
          }.to change { order_item.reload.discount_price }
          expect(order_item.discount_price).to eq(22.46)
        end

        context "required_quantity does not match" do
          let(:quantity) { 2 }
          it "does not set discount price" do
            expect {
             service
            }.to change { order_item.reload.discount_price }
            expect(order_item.discount_price).to eq(22.46)
          end
        end
      end

      context "discount criterias" do
        context "green tea" do
          let(:green_tea)   { create(:product, :green_tea) }
          let(:strawberry)   { create(:product, :strawberry) }
          let(:coffee)   { create(:product, :coffee) }
          let(:order)     { create(:order) }
          let(:order_id) { order.id }
          let(:quantity)  { 3 }
          let!(:order_items) do
            [
              create(:order_item, order: order, product: green_tea, quantity: quantity),
              create(:order_item, order: order, product: strawberry, quantity: 1),
              create(:order_item, order: order, product: coffee, quantity: 1)
            ]
          end

          it "properly applies discount even with other items are added" do
            expect {
             service
            }.to change { order.reload.total_price }
            expect(order.reload.total_price).to eq(22.45)
          end

          context "just green tea is added" do
            let(:quantity) { 2 }
            let!(:order_items) do
              [
                create(:order_item, order: order, product: green_tea, quantity: quantity)
              ]
            end
            it "properly applies discount" do
              expect {
               service
              }.to change { order.reload.total_price }
              expect(order.reload.total_price).to eq(3.11)
            end
          end
        end

        context "strawberry" do
          let(:green_tea)   { create(:product, :green_tea) }
          let(:strawberry)   { create(:product, :strawberry) }
          let(:order)     { create(:order) }
          let(:order_id) { order.id }
          let(:quantity)  { 3 }
          let!(:order_items) do
            [
              create(:order_item, order: order, product: green_tea, quantity: 1),
              create(:order_item, order: order, product: strawberry, quantity: quantity)
            ]
          end

          it "properly applies discount even with other items are added" do
            expect {
             service
            }.to change { order.reload.total_price }
            expect(order.reload.total_price).to eq(16.61)
          end
          context "less than count the bundled items required" do
            let(:quantity)  { 2 }
            it "properly applies discount" do
              expect {
               service
              }.to change { order.reload.total_price }
              expect(order.reload.total_price).to eq(13.11)
            end
          end

          context "more than count the bundled items required" do
            let(:quantity)  { 7 }
            it "properly applies discount" do
              expect {
               service
              }.to change { order.reload.total_price }
              expect(order.reload.total_price).to eq(34.61)
            end
          end
        end

        context "coffee" do
          let(:green_tea)   { create(:product, :green_tea) }
          let(:strawberry)   { create(:product, :strawberry) }
          let(:coffee)   { create(:product, :coffee) }
          let(:order)     { create(:order) }
          let(:order_id) { order.id }
          let(:quantity)  { 3 }
          let!(:order_items) do
            [
              create(:order_item, order: order, product: coffee, quantity: quantity),
              create(:order_item, order: order, product: strawberry, quantity: 1),
              create(:order_item, order: order, product: green_tea, quantity: 1)
            ]
          end

          it "properly applies discount even with other items are added" do
            expect {
             service
            }.to change { order.reload.total_price }
            expect(order.reload.total_price).to eq(30.57)
          end
        end
      end
    end
  end
end
