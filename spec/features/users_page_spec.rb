require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"Wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has made ratings" do
    let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
    let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
    let!(:user) { FactoryBot.create :user, username: "Maija" }
  
    before :each do
      sign_in(username:"Maija", password:"Foobar1")
      FactoryBot.create :rating, beer: beer1, score: 13, user: user
      FactoryBot.create :rating, beer: beer2, score: 22, user: user
    end

    it "has a favorite style" do
      visit user_path(user)
      expect(page).to have_content "Favorite style is Lager"
    end

    it "has a favorite brewery" do
      visit user_path(user)
      expect(page).to have_content "Favorite brewery is Koff"
    end
  end
end
