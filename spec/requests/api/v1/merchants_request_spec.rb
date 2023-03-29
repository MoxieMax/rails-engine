require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  describe "RESTful Endpoints" do
    describe "#index" do
      before :each do
        create_list(:merchant, 5)
        
        get api_v1_merchants_path
        
        expect(response).to be_successful 
        
        @merchants = JSON.parse(response.body, symbolize_names: true)
        @merchant  = @merchants[:data].first 
      end
      
      it "returns all merchants" do
        expect(@merchants).to be_a(Hash)
        expect(@merchants[:data]).to be_an(Array)
        
        expect(@merchants[:data].count).to eq(5)
        expect(@merchants[:data].count).to_not eq(10)
      end
      
      it "can access a single merchant and its attributes" do
        expect(@merchant).to be_a(Hash)
        expect(@merchant).to have_key(:id)
        expect(@merchant).to have_key(:type)
        expect(@merchant).to have_key(:attributes)
        
        expect(@merchant[:type]).to eq("merchant")
        expect(@merchant[:attributes]).to have_key(:name)
      end
    end
    
    describe "#show" do
      before :each do
        @merchant = create(:merchant)

        get api_v1_merchants_path(@merchant)

        expect(response).to be_successful

        @merchants = JSON.parse(response.body, symbolize_names: true)
      end
      
      it "returns a specified merchant" do
        expect(@merchant).to be_a(Merchant)
        expect(@merchant.id).to be_an(Integer)
        expect(@merchant.name).to be_a(String)
      end
      
      xit "returns a 404 error for an invalid ID" do
        get '/api/v1/merchants/24601'
        
        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
  end
end
