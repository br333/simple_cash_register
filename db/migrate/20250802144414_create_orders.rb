class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :uuid, default: "", null: false
      t.decimal :total_price, precision: 10, scale: 2, default: 0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0, null: false
      t.timestamps
    end

    add_index :orders, :uuid, unique: true
  end
end
