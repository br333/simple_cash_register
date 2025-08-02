module Cart
  class CalculatorService < BaseService
    def call
      calculate_order_items_subtotal
      calculate_order_items_total_price
      order.save
      order
    end

    private
    def validate!
      add_error("Order must be present") if @order_id.nil?
      raise_if_invalid!
    end

    def calculate_order_items_subtotal
      order.subtotal = order.order_items.map do |order_item|
        order_item.subtotal = order_item.product.price * order_item.quantity
        order_item.save!
        order_item.subtotal
      end.sum
    end

    def calculate_order_items_total_price
      # can add more
      order.total_price = calculate_order_items_discount_price
    end

    def calculate_order_items_discount_price
      order.order_items.map do |order_item|
        order_item.discount_price = discount_price(order_item)
        order_item.save!
        order_item.discount_price
      end.sum
    end

    def discount_price(order_item)
      # for now use the last promotion rule
      rule = order_item.promotion.promotion_rules.first
      original_price = order_item.product.price
      discount_off = rule.discount
      discounted_price = 0

      case rule.rule_type
      when "fix"
        discounted_price_per_item = (original_price * (discount_off/100.0))
        if order_item.quantity.even?
          discounted_price = discounted_price_per_item * order_item.quantity
        else
          discounted_price = original_price + (discounted_price_per_item * (order_item.quantity - 1))
        end
      when "bundle"
        if rule.required_items_count && order_item.quantity >= rule.required_items_count
          discounted_price_per_item = original_price - (original_price * (discount_off/100.0))
          discounted_price = order_item.quantity * discounted_price_per_item
        else
          discounted_price = order_item.quantity * original_price
        end
      else
        original_price
      end
      discounted_price
    end
  end
end
