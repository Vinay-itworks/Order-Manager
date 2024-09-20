class Product < ApplicationRecord
  has_many :photos, as: :photoable
  
  validates :price, :discount, :description, :name, presence: true
  validates :name, length: { in: 3..100 }
  validates :description, length: { minimum: 5 }
  validates :price, numericality: { greater_than: 0 }
  validates :discount, numericality: { in: 0..99 }
  before_save do |user|
    user.compare_at_price = user.price * (user.discount/100.00)
  end
end
