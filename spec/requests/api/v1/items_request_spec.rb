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
        expect(@item[:type]).to eq('item')
        expect(@item).to have_key(:id)
        expect(@item).to have_key(:type)
        expect(@item).to have_key(:attributes)

        expect(@item[:attributes]).to have_key(:name)
        expect(@item[:attributes]).to have_key(:description)
        expect(@item[:attributes]).to have_key(:unit_price)
        expect(@item[:attributes]).to have_key(:merchant_id)
        
        expect(@item[:attributes][:name]).to be_a(String)
        expect(@item[:attributes][:description]).to be_a(String)
        expect(@item[:attributes][:unit_price]).to be_a(Float)
        expect(@item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    describe "#show" do
      before :each do
        @merchant = create(:merchant)
        @id = create(:item, merchant_id: @merchant.id).id

        get "/api/v1/items/#{@id}"
        
        expect(response).to be_successful
        
        @item = JSON.parse(response.body, symbolize_names: true)
      end
      
      it "returns one item" do
        expect(@item).to be_a(Hash)
        expect(@item).to have_key(:data)
        
        expect(@item[:data]).to have_key(:id)
        expect(@item[:data]).to have_key(:type)
        expect(@item[:data][:type]).to eq("item")
        expect(@item[:data]).to have_key(:attributes)
        
        expect(@item[:data][:attributes]).to have_key(:name)
        expect(@item[:data][:attributes]).to have_key(:description)
        expect(@item[:data][:attributes]).to have_key(:unit_price)
        expect(@item[:data][:attributes]).to have_key(:merchant_id)
      end
      
      xit 'returns a 404 error for an invalid ID' do
        get '/api/v1/items/24601'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
  end
end
