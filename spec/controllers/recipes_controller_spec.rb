require 'rails_helper'

describe RecipesController do
  
  render_views

  describe "GET #index as an external http request" do
    before do
      Recipe.create!(name: 'Baked Potato w/ Cheese')
      Recipe.create!(name: 'Garlic Mashed Potatoes')
      Recipe.create!(name: 'Potatoes Au Gratin')
      Recipe.create!(name: 'Baked Brussel Sprouts')

      xhr :get, :index, format: :json, keywords: keywords
    end
    
    subject(:results) { JSON.parse(response.body) }
    
    context "when the search finds results" do
      let(:keywords) { 'baked' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map{|object| object['name']}).to include('Baked Potato w/ Cheese')
      end
      it "should include 'Baked Brussel Sprouts'" do
        expect(results.map{|object| object['name']}).to include('Baked Brussel Sprouts')
      end
    end
    
    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end  
  
  end

end
