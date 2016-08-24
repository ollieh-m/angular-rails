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
  
  describe 'GET #show as an external http request' do
    before do
      xhr :get, :show, format: :json, id: recipe_id
    end
    
    subject(:results){ JSON.parse(response.body) }
    
    context 'when the recipe exists' do
      let(:recipe){
        Recipe.create!(name: 'Baked potato',
               instructions: 'nuke for 20 minutes')
      }
      let(:recipe_id){ recipe.id }
      it { expect(response.status).to eq(200) }
      it { expect(results["id"]).to eq(recipe.id) }
      it { expect(results["name"]).to eq(recipe.name) }
      it { expect(results["instructions"]).to eq(recipe.instructions) }
    end
      
    context 'when the recipe does not exist' do
      let(:recipe_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end
    
  end

end
