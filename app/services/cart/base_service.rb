require "pry-byebug"
module Cart
  class BaseService
    class CartValidationError < StandardError; end

    attr_reader :errors, :order_id, :product_id, :quantity, :order, :product

    def initialize(params = {})
      @order_id = params[:order_id]
      @product_id = params[:product_id]
      @quantity = params[:quantity]
      @errors = []
      validate!
    end

    def self.call(**args)
      new(**args).call
    end

    def valid?
      errors.empty?
    end

    def add_error(message)
      errors << message if message.present?
    end

    def raise_if_invalid!
      raise CartValidationError, errors.to_sentence unless valid?
    end

    def order
      @order ||= Order.find_by(id: @order_id) || Order.create!
    end

    def product
      @product ||= Product.find_by(id: @product_id)
      add_error("Product not found") if @product.nil?
      raise_if_invalid!
      @product
    end

    private

    def validate!; end
  end
end
