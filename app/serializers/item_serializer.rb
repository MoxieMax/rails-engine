class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id
  
  attribute :merchant_name do |i|
    Merchant.find(i.merchant_id).name
  end
end
