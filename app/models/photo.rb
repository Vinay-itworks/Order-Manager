class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true
  has_one_attached :photo

  validate :attached, on: [ :create, :update ]

  def attached
    errors.add(:photo, "can't be empty") unless photo.attached?
  end
end
