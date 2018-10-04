class PlacesController < ApplicationController
  
  def index
  end

  def show
    places = BeermappingApi.places_in(session[:last_place_search])
    @place = places.find { |place| place.id == params[:id] }
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:last_place_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end