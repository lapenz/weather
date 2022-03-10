class DashboardsController < ApplicationController
  def index
    @data = WeatherGetter.get_by_zipcode(params[:query])
  end
end
