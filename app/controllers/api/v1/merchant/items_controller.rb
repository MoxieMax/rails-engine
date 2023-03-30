class Api::V1::MerchantItemsController < ApplicationController
  def index
    items    = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(items)
  end
end