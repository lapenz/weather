class DashboardsController < ApplicationController
  def index
    # It can be easily changed for accepting different params.
    # No business logic inside the controller :)
    @data = WeatherGetter.get_by_zipcode(params[:query])
  end
end
