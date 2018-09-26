require 'rails_helper'

describe "Beer" do
  before :each do
    FactoryBot.create :brewery, name:"Koff"
  end

  it "is added with valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'testbeer')
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1) 
  end

  it "is not saved without valid name and error message is displayed" do
    visit new_beer_path
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    click_button('Create Beer')
    
    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to eq(0)
  end
end