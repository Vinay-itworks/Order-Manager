class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_product
  has_many :products, through: :cart_product
  validates :user_id, uniqueness: true

  after_initialize do |cart|
    price = 0
    cart.products.each { |product|
      price += product.current_price
    }
    cart.price = price
  end
end
