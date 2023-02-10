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
    # if Item.create(item_params).valid?
    #   render json: ItemSerializer.new(Item.create(item_params)), status: 201
    item = Item.create!(item_params)
    if item.save
        render json: ItemSerializer.new(item), status: 201
    else
      render status: 400
    end
  end
  # 
  # def update
  #   
  # end
  # 
  # def destroy
  #   
  # end
  # 
  private
  
    def item_params
      params.require(:item).permit(:name, :description, :unit_price)
    end
  
end