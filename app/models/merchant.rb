class Merchant < ApplicationRecord
  has_many :items
  
  validates :name, presence: true
end


# Merchants:
# get all merchants
# get one merchant
# get all items for a given merchant ID