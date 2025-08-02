require 'rails_helper'

RSpec.describe PromotionRule, type: :model do
  let(:promotion_rule) { create(:promotion_rule, promotion: create(:promotion)) }

  it "is valid with valid attributes" do
    expect(promotion_rule).to be_valid
  end

  it "should have a promotion" do
    expect(promotion_rule.promotion).to be_present
  end

  it "is not valid without a discount" do
    promotion_rule.discount = nil
    expect(promotion_rule).to_not be_valid
  end

  it "is not valid with a discount less than 0" do
    promotion_rule.discount = -1
    expect(promotion_rule).to_not be_valid
  end

  context "when promotion is not present" do
    it "is not valid" do
      promotion_rule.promotion = nil
      expect(promotion_rule).to_not be_valid
    end
  end
end
