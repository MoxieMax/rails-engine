# class Api::V1::MerchantItemsController < ApplicationController
#   def index
#     items = ItemSerializer.new(Item.where('merchant_id = ?', params[:merchant_id]))
#   end
# end