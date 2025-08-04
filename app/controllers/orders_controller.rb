class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])

    if @order
      render json: @order.as_json(include: { order_items: { include: :product } })
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def update_cart
    order = Cart::UpdateService.call(product_id: params["product_id"], order_id: params["order_id"], quantity: params["quantity"])
    updated_order = Cart::CalculatorService.call(order_id: order.id)
    if updated_order
      render json: updated_order.as_json(include: { order_items: { include: :product } })
    else
      render json: { error: "Failed to update cart" }, status: :unprocessable_entity
    end
  end
end
