require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when ratings exist" do
    before :each do
      user2 = FactoryBot.create(:user, username: "Maija")
      FactoryBot.create :rating, beer: beer1, score: 13, user: user
      FactoryBot.create :rating, beer: beer2, score: 22, user: user
      FactoryBot.create :rating, beer: beer2, score: 15, user: user2
      
    end

    it "page list recent ratings and their total number" do
      visit ratings_path

      expect(page).to have_content "iso 3 13 by Pekka"
      expect(page).to have_content "Karhu 22 by Pekka"
      expect(page).to have_content "Karhu 15 by Maija"
      expect(page).to have_content "Number of ratings: 3"
    end

    it "should show only user's own ratings on user's page" do
      visit user_path(user)

      expect(page).to have_content "iso 3 13"
      expect(page).to have_content "Karhu 22"
      expect(page).to have_content "Has made 2 ratings"
      expect(page).not_to have_content "Karhu 15"
    end

    it "user should be able to delete user's own rating" do
      visit user_path(user)
      page.find('li', text: 'Karhu 22').click_link('delete')

      expect(page).to have_content "iso 3 13"
      expect(page).to have_content "Has made 1 rating"
      expect(page).not_to have_content "Karhu 22"
    end
  end
end