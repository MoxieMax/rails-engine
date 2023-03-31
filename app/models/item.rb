class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, numericality: true, presence: true
  
  def self.find_first_name(name)
    where('name ilike ?', "%#{name}%").order(:name).first
  end
  
end
