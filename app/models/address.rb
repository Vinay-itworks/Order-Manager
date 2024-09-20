class Address < ApplicationRecord
  belongs_to :user

  validates :city, :state, :country, presence: true, length: { maximum: 15 }
  validates :address,  length: { in: 5..50 }
  validates :address_type,  inclusion: { in: %w(Home Work Other),
    message: "%{value} is not a valid must be [Home, Work or Other]" }
  validates :zipcode, length: { in: 5..10 }
end
