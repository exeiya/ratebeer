require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end 
  end

  it "does not save user with too short password" do
    user = User.create username:"Pekka", password:"moi", password_confirmation:"moi"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "does not save user with password consisting of characters only" do
    user = User.create username:"Pekka", password:"thisIsAPassword", password_confirmation:"thisIsAPassword"
    
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)
      
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, 20)
      
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the highest average if many ratings" do
      create_beer_with_many_ratings({ user: user }, 10, 2, 3, 5, 18)
      create_beer_with_rating_and_style({ user: user}, "Weizen", 20)
      best = create_beer_with_rating_and_style({ user: user }, "Pale ale", 24)

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without rating does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of rated beer if only one rating" do
      beer = create_beer_with_rating({ user: user }, 15)
      
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one of highest average beer if many ratings" do
      create_beer_with_many_ratings({ user: user }, 23, 1, 6, 5, 10)
      create_beer_with_rating_and_style({ user: user}, "Unknown brewery", 20)
      best = create_beer_with_rating_and_brewery({ user: user }, "Kumpulan panimo", 24)

      expect(user.favorite_brewery).to eq(best.brewery)
    end
  end
end

def create_beer_with_rating_and_brewery(object, brewery_name, score)
  brewery = FactoryBot.create(:brewery, name: brewery_name)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beer_with_rating_and_style(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beer_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end