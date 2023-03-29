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
      
    end
  end
end
