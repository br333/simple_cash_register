class AddProductToPromotion < ActiveRecord::Migration[8.0]
  def up
    add_reference :promotions, :product, foreign_key: true
  end

  def down
    remove_reference :promotions, :product, foreign_key: true
  end
end
