class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true
      t.integer :quantity
      t.belongs_to :promotion, null: false, foreign_key: true
      t.decimal :discount_price, precision: 10, scale: 2, default: 0, null: false
      t.decimal :total_price, precision: 10, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
