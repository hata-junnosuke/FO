class Product < ApplicationRecord
  validates :code, presence: true
  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0 }
  validates :availability, inclusion: { in: [true, false] }
end
