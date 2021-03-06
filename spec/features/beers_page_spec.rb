require 'rails_helper'

describe "Beer" do
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryBot.create :brewery, name:"Koff"
    FactoryBot.create :style, name:"Lager"
  end

  it "is added with valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'testbeer')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1) 
  end

  it "is not saved without valid name and error message is displayed" do
    visit new_beer_path
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    click_button('Create Beer')
    
    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to eq(0)
  end
end