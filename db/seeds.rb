# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



products = [
  Product.create!(
    name: 'Green Tea',
    description: "Buy one get One free",
    price: 3.11
  ),
  Product.create!(
    name: 'Strawberry',
    description: "Buy more than 3 to get 10% of the price off",
    price: 5.0
  ),
  Product.create!(
    name: 'Coffee',
    description: "Buy more than 3 to get 2/3 each of the price off",
    price: 11.23
  )
]

promotions = [
  Promotion.create!(
    product: products.first,
    code: 'b1g1',
    name: 'Buy one Get 1',
    active: true
  ),
  Promotion.create!(
    product: products.second,
    code: 'bundle',
    name: '10% off',
    active: true
  ),
  Promotion.create!(
    product: products.third,
    code: '2/3 off',
    name: '2/3 off',
    active: true
  )
]


promotion_rules = [
  PromotionRule.create(
    discount: 50,
    required_items_count: nil,
    rule_type: 'fix',
    promotion: promotions.first
  ),
  PromotionRule.create!(
    discount: 10,
    required_items_count: 3,
    rule_type: 'bundle',
    promotion: promotions.second
  ),
  PromotionRule.create!(
    discount: 33.33,
    rule_type: 'bundle',
    promotion: promotions.third,
    required_items_count: 3
  )
]
