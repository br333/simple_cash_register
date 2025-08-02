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
RSpec.describe Promotion, type: :model do
  let(:promotion) { create(:promotion) }

  it "is valid with valid attributes" do
    expect(promotion).to be_valid
  end

  it "is not valid without a name" do
    promotion.name = nil
    expect(promotion).to_not be_valid
  end

  context "when promo code validation" do
    let(:duplicate_promotion) { create(:promotion, code: "12345678") }

    it "generates code if code is blank" do
      promotion.code = nil
      expect(promotion).to be_valid
      expect(promotion.code).to_not be_nil
    end

    it "is valid with a promo code" do
      promotion.code = "12345678"
      expect(promotion).to be_valid
    end

    it "generates code if code is duplicate" do
      promotion.code = duplicate_promotion.code
      expect(promotion).to be_valid
      expect(promotion.code).to_not be_nil
      expect(promotion.code).to_not eq(duplicate_promotion.code)
    end

    it "generates code if code is nil" do
      promotion.code = nil
      expect(promotion).to be_valid
      expect(promotion.code).to_not be_nil
      expect(promotion.code).to_not eq(duplicate_promotion.code)
    end
  end

  context "when promo rule is present" do
    let!(:promotion_rule) { create(:promotion_rule, promotion: promotion) }

    it "is valid with a promo rule" do
      expect(promotion).to be_valid
    end

    it "destroys promo rule when promotion is destroyed" do
      expect {
        promotion.destroy
      }.to change { PromotionRule.count }.by(-1)
    end
  end
end
