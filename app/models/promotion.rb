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
class Promotion < ApplicationRecord
  has_many :promotion_rules, dependent: :destroy
  belongs_to :product

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  before_validation :generate_code

  private

  def generate_code
    if code.blank? || Promotion.where.not(id: id).exists?(code: code)
      self.code = loop do
        random_code = SecureRandom.hex(8).upcase
        break random_code unless Promotion.exists?(code: random_code)
      end
    end
  end
end
