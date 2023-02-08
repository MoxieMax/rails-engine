require 'rails_helper'

RSpec.describe 'Merchant API' do
  describe 'RESTful Endpoints' do
    before :each do
      create_list(:merchant, 10)

      get api_v1_merchants_path

      expect(response).to be_successful

      @merchants = JSON.parse(response.body, symbolize_names: true)
    end
    
    it 'returns all merchants' do
      expect(@merchants).to be_a(Hash)
      expect(@merchants[:data]).to be_an(Array)
    end
    
    xit 'returns one merchant' do
      
    end
    
    xit 'returns all items for a given merchant ID' do
      
    end
  end
  
end
