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
      
      it 'returns a 404 error for an invalid ID' do
        get '/api/v1/items/24601'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
    
    describe "#create" do
      it "can create an item using given params" do
        merchant    = create(:merchant)
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
    
    describe "#update" do
      it 'can edit an item' do
        merchant    = create(:merchant)
        item        = create(:item, merchant_id: merchant.id)
        name        = item.name
        description = item.description
        unit_price  = item.unit_price
        item_params = ({
                        name: "Shiny thing",
                        description: "lorem ipsum dolor sit amet",
                        unit_price: 14.50,
                        merchant_id: merchant.id
                      })
        headers     = { "CONTENT_TYPE" => "application/json" }
        
        expect(name).to eq(item.name)
        expect(description).to eq(item.description)
        expect(unit_price).to eq(item.unit_price)
        
        patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
        
        item = Item.last
        
        get api_v1_item_path(item)
        
        expect(response).to be_successful
        
        expect(item.name).to eq(item_params[:name])
        expect(item.name).to_not eq(name)
        
        expect(item.description).to eq(item_params[:description])
        expect(item.name).to_not eq(description)
        
        expect(item.unit_price).to eq(item_params[:unit_price])
        expect(item.name).to_not eq(unit_price)
        
        expect(response).to have_http_status(200)
      end
      
      it "won't update with invalid information" do
        merchant    = create(:merchant)
        item        = create(:item, merchant_id: merchant.id)
        name        = item.name
        description = item.description
        unit_price  = item.unit_price
        item_params = ({
                        name: ,
                        description: "lorem ipsum dolor sit amet",
                        unit_price: 14.50,
                        merchant_id: 24601
                      })
        headers     = { "CONTENT_TYPE" => "application/json" }
        
        patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
        
        expect(response).to_not be_successful
      end
      
      it "can't update an item that doesn't exist" do
        get "/api/v1/items/24601"
        
        expect(response).to_not be_successful
      end
    end
    
    describe "#destroy" do
      it 'can delete an item' do
        merchant = create(:merchant)
        item     = create(:item, merchant_id: merchant.id)
        
        expect(Item.count).to eq(1)
        
        delete api_v1_item_path(item)
        
        expect(Item.count).to eq(0)
        
        get "/api/v1/items/#{item.id}"
        
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
    
    describe "#merchants_items" do
      it "returns the merchant data for a given item " do
        merchant = create(:merchant)
        item     = create(:item, merchant_id: merchant.id)

        get api_v1_items_path(item)
        expect(response).to be_successful
        
        merch_info = JSON.parse(response.body, symbolize_names: true)
        data       = merch_info[:data].first
        attributes = data[:attributes]
        
        expect(merch_info).to be_a(Hash)
        expect(data).to be_a(Hash)
        expect(attributes).to be_a(Hash)
        
        expect(data).to have_key(:attributes)
        
        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to eq(merchant.id)
        
        expect(attributes).to have_key(:merchant_name)
        expect(attributes[:merchant_name]).to eq(merchant.name)
      end
    end
    
    describe "#search" do
      xit "can search for an item by name, returns first result alphabetically" do
        merchant = Merchant.create!(name: 'Testing')
        item1    = Item.create!(name: 'Ring World', description: 'get', unit_price: 1, merchant_id: merchant.id)
        item2    = Item.create!(name: 'Turing', description: 'good', unit_price: 1, merchant_id: merchant.id)
        item3    = Item.create!(name: 'Neither', description: 'scrub', unit_price: 1, merchant_id: merchant.id)
        
        get api_v1_items_find_path, params: { name: 'Ring' }
        # binding.pry
        expect(response).to be_successful
        
        items = JSON.parse(response.body, symbolize_names: true)
        
        expect(items[:data][:attributes][:name]).to eq(item1.name)
        expect(items[:data][:attributes][:name]).to not_include(item2.name)
        
      end
    end
  end
end
