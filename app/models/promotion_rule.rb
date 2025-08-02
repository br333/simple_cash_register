class PromotionRule < ApplicationRecord
  belongs_to :promotion

  validates :discount, presence: true, numericality: { greater_than: 0 }
end
