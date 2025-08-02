class CreatePromotionRules < ActiveRecord::Migration[8.0]
  def change
    create_table :promotion_rules do |t|
      t.belongs_to :promotion, null: false, foreign_key: true
      t.datetime :expiration_date
      t.float :discount

      t.timestamps
    end
  end
end
