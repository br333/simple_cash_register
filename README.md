# simple_cash_register

This Ruby on Rails application supports a shopping cart with dynamic pricing rules and promotions, including:

- Fixed discounts (e.g. Buy 1 Get 1)
- Bundled pricing
- Product-specific promotions

---

## 🧪 Test Setup

This app uses RSpec and FactoryBot for a robust testing suite. Tests cover:

- Order recalculations
- Product promotions
- Order item discount logic
- Edge cases (e.g. mixed promotions, invalid orders)

### Installing
```bash
 bundle install
 rails db:create db:migrate db:seed
```
---

### Seeding the Database

IMPORTANT:
You must run the seeds to populate the database with the required products and discount rules for the promotions to be available and work correctly in the UI.
---

### Running the Test Suite

```bash
bundle exec rspec
```

### Lints

```bash
bundle exec rubocop
```

### Sample Spec Structure

```ruby
RSpec.describe Cart::CalculatorService do
    let(:order) { create(:order) }

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
    end
end
```

### Known limitations
- Data is stored in localStorage since we don't have user to associate the orders.
- Need to run the seed in order for the proper discounts and products to be available in the UI.
- UI has no tests.