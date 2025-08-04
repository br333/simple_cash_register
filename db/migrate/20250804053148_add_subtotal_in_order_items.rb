class AddSubtotalInOrderItems < ActiveRecord::Migration[8.0]
  def up
    add_column :order_items, :subtotal, :decimal, precision: 10, scale: 2, null: false, default: 0
  end

  def down
    remove_column :order_items, :subtotal
  end
end
