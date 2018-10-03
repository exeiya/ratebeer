require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  it "if many places are returned by the API, all of them are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ),
        Place.new( name:"Grilli", id: 2 ),
        Place.new( name:"Kolmas Baari", id: 3 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Grilli"
    expect(page).to have_content "Kolmas Baari"
  end
  it "if no places are returned by the API, notification is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("nowhere").and_return([])

    visit places_path
    fill_in('city', with: 'nowhere')
    click_button "Search"

    expect(page).to have_content "No locations in nowhere"
  end
end