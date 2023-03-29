class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end
  
  def show
    if Item.find_by(id: params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render status: 404
    end
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
  
  def destroy
    Item.delete(params[:id])
  end
  
  private
  
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
