class User < ApplicationRecord
  has_many :addresses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, :last_name, presence: true, length: { in: 3..15 }
  validates :birthdate, comparison: { less_than: 5.years.ago.to_date, message: "You must be 5 years old."}

  before_save do |user|
    user.age = ((Time.zone.now - user.birthdate.to_time) / 1.year.seconds).floor
  end
end
