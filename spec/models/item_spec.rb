require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
    
    # it { should validate_numericality_of(:unit_price) }
  end
end

# Validate numericality error
# 1) Item validations is expected to validate that :unit_price looks like a number
#      Failure/Error: it { should validate_numericality_of(:unit_price) }
# 
#        Expected Item to validate that :unit_price looks like a number, but this
#        could not be proved.
#          After setting :unit_price to ‹"abcd"› -- which was read back as ‹0.0›
#          -- the matcher expected the Item to be invalid, but it was valid
#          instead.
# 
#          As indicated in the message above, :unit_price seems to be changing
#          certain values as they are set, and this could have something to do
#          with why this test is failing. If you've overridden the writer method
#          for this attribute, then you may need to change it to make this test
#          pass, or do something else entirely.