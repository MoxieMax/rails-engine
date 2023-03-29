require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "RESTful Endpoints" do
    describe "#index" do
      before :each do
        @merchant = create(:merchant)
        
        create_list(:item, 10, merchant_id: @merchant.id)
        
        get api_v1_items_path
        
        expect(response).to be_successful
        
        @items = JSON.parse(response.body, symbolize_names: true)
        @item = @items[:data].first
      end
      
      it 'returns all items' do
        expect(@items).to be_a(Hash)
        expect(@items[:data]).to be_an(Array)
        expect(@items[:data].count).to eq(10)
        expect(@items[:data].first).to have_key(:id)
        expect(@items[:data].first).to have_key(:type)
      end
      
      it 'can access a specific item and its attributes' do
        #further tested within the #show tests
        expect(@item[:type]).to eq('item')
        expect(@item).to have_key(:id)
        expect(@item).to have_key(:type)
        expect(@item).to have_key(:attributes)
      end
    end
    
    describe "#show" do
      before :each do
        @merchant = create(:merchant)
        @id       = create(:item, merchant_id: @merchant.id).id

        get "/api/v1/items/#{@id}"
        
        expect(response).to be_successful
        
        @item = JSON.parse(response.body, symbolize_names: true)
      end
      
      it "returns one item" do
        data       = @item[:data]
        attributes = data[:attributes]
        
        expect(@item).to be_a(Hash)
        expect(@item).to have_key(:data)
        
        
        expect(data).to have_key(:id)
        expect(data).to have_key(:type)
        expect(data[:type]).to eq("item")
        expect(data).to have_key(:attributes)
        
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        
        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)
        
        expect(attributes).to have_key(:unit_price)
        expect(attributes[:unit_price]).to be_a(Float)
        
        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to be_a(Integer)
      end
      
      xit 'returns a 404 error for an invalid ID' do
        get '/api/v1/items/24601'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
    
    describe "#create" do
      it "can create an item using given params" do
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
        
        get api_v1_items_path(item)
        
        expect(item.name).to eq(item_params[:name])
        expect(item.description).to eq(item_params[:description])
        expect(item.unit_price).to eq(item_params[:unit_price])
        expect(item.merchant_id).to eq(item_params[:merchant_id])
        expect(item.merchant_id).to eq(merchant.id)
      end
    end
    
    describe "#edit" do
      it 'can edit an item' do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)
        name = item.name
        description = item.description
        unit_price = item.unit_price
        item_params = ({
                        name: "Shiny thing",
                        description: "lorem ipsum dolor sit amet",
                        unit_price: 14.50,
                        merchant_id: merchant.id
                      })
        headers = { "CONTENT_TYPE" => "application/json" }
        
        expect(name).to eq(item.name)
        expect(description).to eq(item.description)
        expect(unit_price).to eq(item.unit_price)
        
        patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
        
        item = Item.last
        
        get api_v1_item_path(item)
        
        expect(response).to be_successful
        
        expect(item.name).to eq(item_params[:name])
        expect(item.description).to eq(item_params[:description])
        expect(item.unit_price).to eq(item_params[:unit_price])
        binding.pry
      end
    end
    
    describe "#delete" do
      it 'can delete an item' do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)
        
        expect(Item.count).to eq(1)
        item.delete
        expect(Item.count).to eq(0)
      end
    end
  end
end
