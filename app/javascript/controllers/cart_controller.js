// app/javascript/controllers/cart_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]
  static values = {
    productId: Number
  }

  connect() {
    this.getCart()
  }

  async addToCart() {
    const cart = JSON.parse(localStorage.getItem("cart"))
    let quantity = parseInt(this.quantityTarget.innerText, 10) + 1
    this.quantityTarget.innerText = quantity
  
    const orderId = cart.id
    const productId = this.productIdValue
  
    this.updateOrder({ orderId, productId, quantity })
  }

  async removeToCart() {
    const cart = await this.getCart()
    let quantity = Math.max(0, parseInt(this.quantityTarget.innerText, 10) - 1)
    this.quantityTarget.innerText = quantity
  
    const orderId = cart?.id
    const productId = this.productIdValue
  
    await this.updateOrder({ orderId, productId, quantity })
  }

  async getCart() {
    try {
      const storedCart = localStorage.getItem("cart")
      let cart = storedCart ? JSON.parse(storedCart) : null
  
      if (cart?.id) {
        const res = await fetch(`/orders/${cart.id}`)
        if (!res.ok) throw new Error("Failed to fetch cart from server")
  
        const data = await res.json()
        this.saveCart(data)
        this.renderCartSummary(data)
        this.syncProductQuantities(data)
        return data
      } else {
        const emptyCart = { id: null, order_items: [], subtotal: 0, total_price: 0 }
        this.saveCart(emptyCart)
        this.renderCartSummary(emptyCart)
        this.syncProductQuantities(emptyCart)
        return emptyCart
      }
    } catch (error) {
      console.error("getCart error:", error)
      return { id: null, order_items: [], subtotal: 0, total_price: 0 }
    }
  }

  saveCart(cart) {
    localStorage.setItem("cart", JSON.stringify(cart))
  }

  async updateOrder({ orderId, productId, quantity }) {
    try {
      const response = await fetch("/orders/update_cart", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({
          order_id: orderId,
          product_id: productId,
          quantity: quantity
        })
      });

      if (!response.ok) throw new Error("Error updating cart")

      const data = await response.json()
      this.saveCart(data)
      this.renderCartSummary(data)
    } catch (error) {
      console.error("Failed to update cart:", error)
    }
  }

  renderCartSummary(data = null) {
    const tbody = document.getElementById("cart-summary-body")
    const totalElement = document.getElementById("cart-summary-total")
    const subTotalElement = document.getElementById("cart-summary-subtotal")
    const cart = data || JSON.parse(localStorage.getItem("cart"))
    tbody.innerHTML = "" 

    if (!cart || !Array.isArray(cart.order_items) || cart.order_items.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" class="has-text-centered">Cart is empty</td></tr>`
      totalElement.innerText = `€0.00`
      subTotalElement.innerText = `€0.00`
      return
    }

    cart.order_items.forEach(item => {
      const tr = document.createElement("tr")
      tr.innerHTML = `
        <td>${item.product?.name || "Unknown"}</td>
        <td>${item.quantity}</td>
        <td class="has-text-right">€${parseFloat(item.product?.price || 0)}</td>
        <td class="has-text-right">€${parseFloat(item.total_price || 0)}</td>
      `
      tbody.appendChild(tr)
    })

    totalElement.innerText = `€${parseFloat(cart.total_price || 0)}`
    subTotalElement.innerText = `€${parseFloat(cart.subtotal || 0)}`
  }

  syncProductQuantities(cart) {
    const rows = document.querySelectorAll("[data-cart-product-id-value]")
    
    rows.forEach(row => {
      const productId = parseInt(row.dataset.cartProductIdValue, 10)
      const quantityTarget = row.querySelector("[data-cart-target='quantity']")
        const item = cart.order_items.find(i => i.product.id === productId)
      if (quantityTarget) {
        quantityTarget.innerText = item ? item.quantity : 0
      }
    })
  }
}