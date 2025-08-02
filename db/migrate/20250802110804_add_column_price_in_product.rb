class AddColumnPriceInProduct < ActiveRecord::Migration[8.0]
  def up
    add_column :products, :price, :decimal, precision: 10, scale: 2, null: false, default: 0
  end

  def down
    remove_column :products, :price
  end
end
