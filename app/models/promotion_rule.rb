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
class PromotionRule < ApplicationRecord
  include Ruleable
  belongs_to :promotion

  validates :discount, presence: true, numericality: { greater_than: 0 }
  validates :rule_type, inclusion: { in: PROMOTION_RULES }
end
