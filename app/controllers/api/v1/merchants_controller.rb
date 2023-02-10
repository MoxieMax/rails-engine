  class Api::V1::MerchantsController < ApplicationController
    # rescue_from ActiveRecord::RecordNotFound, with: :error_response
    # 
    #   def error_response(error)
    #     render json: ErrorSerializer.error_json(error), status: 404
    #   end
      
    def index
      render json: MerchantSerializer.new(Merchant.all)
    end
    
    def show
      if params[:item_id]
        render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
      elsif merchant = Merchant.find_by(id: params[:id])
        render json: MerchantSerializer.new(merchant)
      else
        render status: 404
      end
    end
  end
  
  # if params[:item_id]
  #   item = Item.find(params[:item_id])
  #   render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
  # else
  #   render json: MerchantSerializer.new(Merchant.find(params[:id]))
  # end