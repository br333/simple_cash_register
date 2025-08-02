class Promotion < ApplicationRecord
  has_many :promotion_rules, dependent: :destroy

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
