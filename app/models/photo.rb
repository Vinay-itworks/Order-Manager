class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true
  has_one_attached :photo
end
