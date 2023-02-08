class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, numericality: true, presence: true
end
# Items:
# get all items
# get one item
# create an item
# edit an item
# delete an item
# get the merchant data for a given item ID