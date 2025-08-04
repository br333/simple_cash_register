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
FactoryBot.define do
  factory :promotion_rule do
    discount { 10 }
    expiration_date { 1.day.from_now }
    rule_type { %w[fix bundle].sample }
    required_items_count { nil }
    association :promotion
  end
end
