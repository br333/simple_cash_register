require 'pry-byebug'
# == Schema Information
#
# Table name: promotion_rules
#
#  id                   :integer          not null, primary key
#  discount             :float
#  expiration_date      :datetime
#  required_items_count :integer
#  rule_type            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  promotion_id         :integer          not null
#
# Indexes
#
#  index_promotion_rules_on_promotion_id  (promotion_id)
#
# Foreign Keys
#
#  promotion_id  (promotion_id => promotions.id)
#
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

  context "when type is not in PROMOTION_RULES" do
    it "is not valid" do
      promotion_rule.rule_type = 'test'
      expect(promotion_rule).to_not be_valid
    end
  end
end
