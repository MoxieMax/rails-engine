class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :error_response
    
    def error_response(error)
      render json: ErrorSerializer.error_json(error), status: 404
    end
    
  def index
    render json: ItemSerializer.new(Item.all)
  end
  
  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
  
  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end
  
  def update
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      if item.update(item_params)
        render json: ItemSerializer.new(item)
      else
        render json: { error: 'Item not updated' }, status: 404
      end
    else
      error_response(error)
    end
  end
    # if item = Item.update(params[:id], item_params)
    #   render json: ItemSerializer.new(item)
    # else
    #   render status: 400
    # end
  
  def destroy
    Item.delete(params[:id])
  end
  
  private
  
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
  
end