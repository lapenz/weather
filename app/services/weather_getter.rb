# Services classes is a very important and well known design pattern which allow us to separate business logic
# from the controller layer. By doing this, the logic here can be reused in many different places and also become much
# easier to test and maintain the code, since its more modular and decoupled.
class WeatherGetter
  # These env vars allow to easily change the API info and also the params without changing the code
  API_KEY = ENV['WEATHER_API_KEY']
  API_URL = ENV['WEATHER_API_URL']
  DEFAULT_OPTIONS = {units: ENV['WEATHER_DEFAULT_UNIT']}

  # Main method which is responsible for pulling the data based on many different params and returning it properly to
  # be used.
  # Error handling here is important since we can have issues trying to pull the data.
  # Generic method that can be used directly or also reused by other methods if needed.
  def self.call(searchKey, searchValue, options = DEFAULT_OPTIONS)
    return OpenStruct.new(success?: false) if searchValue.blank? || searchKey.blank?

    options[searchKey] = searchValue
    OpenStruct.new(success?: true,
                   cache_data?: CacheManager.exist_in_cache?(options),
                   result: CacheManager.get_value(options, &method(:get_json)))
  rescue => e
    OpenStruct.new(success?: false, error: e.message)
  end

  # Get weather data by zipcode
  def self.get_by_zipcode(zipcode, options = DEFAULT_OPTIONS)
    self.call(:zip, zipcode, options)
  end

  # Get weather data by city name
  def self.get_by_city(city, options = DEFAULT_OPTIONS)
    self.call(:q, city, options)
  end

  private

  # Responsible for pulling data from API.
  # Since this is an internal logic its better to encapsulate it.
  def self.get_json(options)
    JSON.parse RestClient.get API_URL, {params: {appid: API_KEY, **options}}
  end
end