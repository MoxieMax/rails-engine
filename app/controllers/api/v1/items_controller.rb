class Api::V1::ItemsController < ApplicationController
  def index
    if Item.where(merchant_id: params[:merchant_id]).exists?
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    elsif params[:merchant_id] && !Item.where(merchant_id: params[:merchant_id]).exists?
      render status: 404
    else
      render json: ItemSerializer.new(Item.all)
    end
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
      render status: 404
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
