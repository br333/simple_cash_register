FactoryBot.define do
  factory :promotion_rule do
    discount { 10 }
    expiration_date { 1.day.from_now }
  end
end
