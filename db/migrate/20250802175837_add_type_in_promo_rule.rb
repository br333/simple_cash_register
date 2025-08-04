class AddTypeInPromoRule < ActiveRecord::Migration[8.0]
  def up
    add_column :promotion_rules, :rule_type, :string, default: nil
  end

  def down
    remove_column :promotion_rules, :rule_type
  end
end
