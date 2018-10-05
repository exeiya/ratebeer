require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved when name, style and brewer properly set" do
    test_brewery = Brewery.create name:"testbrewery", year: 2000
    test_style = Style.create name:"teststyle", description:"very good"
    beer = Beer.create name:"testbeer", style: test_style, brewery: test_brewery

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
