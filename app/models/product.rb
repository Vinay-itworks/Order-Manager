class Product < ApplicationRecord
  has_many :photos, as: :photoable
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :cart_product
  has_many :carts, through: :cart_product
  has_many :users, through: :carts
  validates :price, :discount, :description, :name, presence: true
  validates :name, length: { in: 3..100 }
  validates :description, length: { minimum: 5 }
  validates :price, numericality: { greater_than: 0 }
  validates :discount, numericality: { in: 0..99 }
  before_save do |product|
    product.compare_at_price = product.price * (product.discount/100.00)
  end

  after_find do |product|
    product.current_price = (product.price - product.compare_at_price).floor
  end
end
