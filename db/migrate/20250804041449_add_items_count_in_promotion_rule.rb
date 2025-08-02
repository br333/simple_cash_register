class AddItemsCountInPromotionRule < ActiveRecord::Migration[8.0]
  def up
    add_column :promotion_rules, :required_items_count, :integer, default: nil
  end

  def down
    remove_column :promotion_rules, :required_items_count
  end
end
