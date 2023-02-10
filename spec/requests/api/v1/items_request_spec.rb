require 'rails_helper'

RSpec.describe 'Item API' do
  describe 'RESTful Endpoints' do
    describe '#index tests' do
      before :each do
        @merchant = create(:merchant)
        create_list(:item, 10, merchant_id: @merchant.id)
        
        get api_v1_items_path
        
        expect(response).to be_successful
        
        @items = JSON.parse(response.body, symbolize_names: true)
      end
      
      it 'returns all items' do
        expect(@items).to be_a(Hash)
        expect(@items[:data]).to be_an(Array)
        expect(@items[:data].count).to eq(10)
        expect(@items[:data].first).to have_key(:id)
        expect(@items[:data].first).to have_key(:type)
      end
      
      it 'can access a specific item and its attributes' do
        item1 = @items[:data].first
        
        expect(item1[:type]).to eq('item')
        expect(item1.keys).to eq([:id, :type, :attributes])
        expect(item1[:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
        expect(item1[:attributes][:name]).to be_a(String)
        expect(item1[:attributes][:description]).to be_a(String)
        expect(item1[:attributes][:unit_price]).to be_a(Float)
        expect(item1[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    describe '#show tests' do
      it 'returns one item' do
        merchant = create(:merchant)
        id = create(:item, merchant_id: merchant.id).id

        get "/api/v1/items/#{id}"

        item1 = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        
        expect(item1).to have_key(:data)
        expect(item1[:data]).to have_key(:id)
        expect(item1[:data]).to have_key(:type)
        expect(item1[:data]).to have_key(:attributes)
        
        
        expect(item1).to be_a(Hash)
        expect(item1).to have_key(:data)
        
        expect(item1[:data]).to be_a(Hash)
        expect(item1[:data]).to have_key(:id)
        expect(item1[:data][:id]).to be_a(String)
        expect(item1[:data]).to have_key(:attributes)
        
        expect(item1[:data][:attributes]).to be_a(Hash)
        expect(item1[:data][:attributes]).to have_key(:name)
        expect(item1[:data][:attributes][:name]).to be_a(String)
        expect(item1[:data][:attributes]).to have_key(:description)
        expect(item1[:data][:attributes][:description]).to be_a(String)
        expect(item1[:data][:attributes]).to have_key(:unit_price)
        expect(item1[:data][:attributes][:unit_price]).to be_a(Float)
      end
      
      it 'returns a 404 error for an invalid ID' do
        get '/api/v1/items/98765'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
    
    describe '#create tests' do
      it 'can create an item' do
        merchant = create(:merchant)
        item_params = ({
                        name: "Shiny thing",
                        description: "lorem ipsum dolor sit amet",
                        unit_price: 14.50,
                        merchant_id: merchant.id
                      })
        headers = { "CONTENT_TYPE" => "application/json" }
        
        post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

        item = Item.last
        
        expect(response).to be_successful
        
        get api_v1_item_path(item)
        
        expect(item.name).to eq(item_params[:name])
        expect(item.description).to eq(item_params[:description])
        expect(item.unit_price).to eq(item_params[:unit_price])
        expect(item.merchant_id).to eq(item_params[:merchant_id])
        expect(item.merchant_id).to eq(merchant.id)
      end
    end
    
    describe '#edit tests' do
      xit 'can edit an item' do
        
      end
    end
    
    describe '#destroy tests' do
      it 'can delete an item' do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)
        
        expect(Item.count).to eq(1)
        item.delete
        expect(Item.count).to eq(0)
      end
    end
    
    describe 'merchant data tests' do
      xit 'can return merchant data for a given item ID' do
        
      end
    end
  end
  
end