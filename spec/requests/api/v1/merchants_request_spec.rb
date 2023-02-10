require 'rails_helper'

RSpec.describe 'Merchant API' do
  describe 'RESTful Endpoints' do
    describe '#index tests' do
      before :each do
        create_list(:merchant, 10)
        
        get api_v1_merchants_path
        
        expect(response).to be_successful
        
        @merchants = JSON.parse(response.body, symbolize_names: true)
        @merchant1 = @merchants[:data].first
      end
      
      it 'returns all merchants' do
        expect(@merchants).to be_a(Hash)
        expect(@merchants[:data]).to be_an(Array)
        expect(@merchants[:data].count).to eq(10)
        expect(@merchants[:data].first).to have_key(:id)
        expect(@merchants[:data].first).to have_key(:type)
      end
      
      it 'can access a specific merchant and their attributes' do
        expect(@merchant1[:type]).to eq('merchant')
        expect(@merchant1[:attributes]).to have_key(:name)
        expect(@merchant1[:attributes][:name]).to be_a(String)
      end
    end
    
    describe '#show tests' do
      before :each do
        @merchant = create(:merchant)

        get api_v1_merchants_path(@merchant)

        expect(response).to be_successful

        @merchants = JSON.parse(response.body, symbolize_names: true)
      end
      
      it 'returns one merchant #show' do
        expect(@merchant).to be_a(Merchant)
        expect(@merchant.id).to be_an(Integer)
        expect(@merchant.name).to be_a(String)
      end
      
      it 'returns a 404 error for an invalid ID' do
        get '/api/v1/merchants/98765'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
      
    end
    
    describe 'merchant items' do
      before :each do
        @merchant = create(:merchant)
        create_list(:item, 10, merchant_id: @merchant.id)
        # binding.pry
        get api_v1_merchant_items_path(@merchant)
        
        expect(response).to be_successful
        
        @items = JSON.parse(response.body, symbolize_names: true)
      end
      
      it 'returns all items for a given merchant ID' do
        item1 = @items[:data].first
        
        expect(@merchant).to be_a(Merchant)
        expect(@items).to be_a(Hash)
        expect(@items[:data]).to be_an(Array)
        expect(@items[:data].count).to eq(10)
        expect(item1[:id]).to be_a(String)
        expect(item1[:id].to_i).to be_an(Integer) #if it wasn't a number, it wouldn't convert
        expect(item1[:type]).to eq('item')
        expect(item1[:attributes]).to be_a(Hash)
        expect(item1[:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      end
    end
  end
end