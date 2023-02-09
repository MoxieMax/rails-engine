require 'rails_helper'

RSpec.describe 'Item API' do
  describe 'RESTful Endpoints' do
    describe '#index tests' do
      before :each do
        @merchant = create(:merchant)
        create_list(:item, 10, merchant_id: @merchant.id)
        # binding.pry
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
      before :each do
        @merchant = create(:merchant)
        @item = create(:item, merchant_id: @merchant.id)

        get api_v1_items_path(@item)

        expect(response).to be_successful

        @items = JSON.parse(response.body, symbolize_names: true)
      end
      
      it 'returns one item' do
        expect(@item).to be_an(Item)
        expect(@item.id).to be_an(Integer)
        expect(@item.name).to be_a(String)
        expect(@item.description).to be_a(String)
        expect(@item.unit_price).to be_a(Float)
      end
      
      xit 'returns a 404 error for an invalid ID' do
        get 'api/v1/items/98765'
      
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
    
    describe '#new tests' do
      before :each do
        @merchant = create(:merchant)
        
      end
      
      it 'can create an item' do
        item_params = ({
                        name: "Nail Polish",
                        description: "lorem ipsum",
                        unit_price: 14.50,
                        merchant_id: @merchant.id
                    })
        headers = {"CONTENT_TYPE" => "application/json"}
        
        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
        
        created_item = Item.last
        
        expect(response).to be_successful
        
        
      end
    end
    
    describe '#edit tests' do
      xit 'can edit an item' do
        
      end
    end
    
    describe '#destroy tests' do
      xit 'can delete an item' do
        
      end
    end
    
    describe 'merchant data tests' do
      xit 'can return merchant data for a given item ID' do
        
      end
    end
  end
  
end