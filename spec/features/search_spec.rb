require 'rails_helper'

feature 'Looking up recipes', js: true do
  before do
    Recipe.create!(name: 'Baked Potato w/ Cheese')
    Recipe.create!(name: 'Garlic Mashed Potatoes')
    Recipe.create!(name: 'Potatoes Au Gratin')
    Recipe.create!(name: 'Baked Brussel Sprouts')
  end
  scenario 'and finding them' do
    visit '/'
    fill_in 'keywords', with: 'baked'
    click_on 'Search'
    
    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end
end