class ChangePromotionIdInOrderItems < ActiveRecord::Migration[8.0]
  def change
    change_column_null :order_items, :promotion_id, true
  end
end
