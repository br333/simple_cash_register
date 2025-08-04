# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  subtotal    :decimal(10, 2)   default(0.0), not null
#  total_price :decimal(10, 2)   default(0.0), not null
#  uuid        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_uuid  (uuid) UNIQUE
#
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_unique_uuid

  private

  def set_unique_uuid
    if uuid.blank? || Order.where.not(id: id).exists?(uuid: uuid)
      self.uuid = loop do
        random = SecureRandom.uuid
        break random unless Order.exists?(uuid: random)
      end
    end
  end
end
