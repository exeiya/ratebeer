require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved when name, style and brewer properly set" do
    test_brewery = Brewery.create name:"testbrewery", year: 2000
    beer = Beer.create name:"testbeer", style:"teststyle", brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved when style is not set" do
    test_brewery = Brewery.create name:"testbrewery", year: 2000
    beer = Beer.create name:"testbeer", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
