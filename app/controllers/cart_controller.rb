class CartController < ApplicationController
  def index
    @products = Product.all
  end

  def update_cart
    render json: { status: "success", message: "Cart updated", cart: cart_data }
  end
end
