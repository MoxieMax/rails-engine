require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  describe "RESTful Endpoints" do
    before :each do
      create_list(:merchant, 5)
      
      get api_v1_merchants_path
      
      expect(response).to be_successful 
      
      @merchants = JSON.parse(response.body, symbolize_names: true)
      @merchant  = @merchants[:data].first 
    end
    
    it "#index returns all merchants" do
      expect(@merchants).to be_a(Hash)
      expect(@merchants[:data]).to be_an(Array)
      
      expect(@merchants[:data].count).to eq(5)
      expect(@merchants[:data].count).to_not eq(10)
      
      # expect(@merchants[:data]).to
      # expect(@merchants[:data]).to
      # expect(@merchants[:data]).to
    end
  end
end
