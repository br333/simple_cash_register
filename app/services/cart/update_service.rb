module Cart
  class UpdateService < BaseService
    def call
      update_items
      recalculate_order
      order
    end

    private

    def update_items
      order_item = order.order_items
                        .find_or_initialize_by(product_id: product.id)
      order_item.quantity    = @quantity
      order_item.total_price = product.price
      order_item.promotion ||= product.promotion

      add_error("Failed to add items") unless order_item.save!
      order_item
    end

    def recalculate_order
      # calculate service here
    end

    def validate!
      add_error("Product must be present") if product_id.nil?
      add_error("Quantity must be greater than 0") if quantity.to_i <= 0
      raise_if_invalid!
    end
  end
end
