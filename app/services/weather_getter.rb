class WeatherGetter
  API_KEY = 'e155ba888319d33e0b85dec3fa93ef64'
  API_URL = "https://api.openweathermap.org/data/2.5/weather"
  DEFAULT_CACHE_EXPIRATION_TIME = 30.minutes
  DEFAULT_OPTIONS = {units: 'metric'}

  def self.call(searchKey, searchValue, options = DEFAULT_OPTIONS)
    return OpenStruct.new(success?: false) if searchValue.blank? || searchKey.blank?
    options[searchKey] = searchValue
    OpenStruct.new(success?: true,
                   cache_data?: exist_in_cache?(options),
                   result: get_cached_result(options))
  rescue => e
    OpenStruct.new(success?: false, error: e.message)
  end

  def self.get_by_zipcode(zipcode, options = DEFAULT_OPTIONS)
    self.call(:zip, zipcode, options)
  end

  def self.get_by_city(city, options = DEFAULT_OPTIONS)
    self.call(:q, city, options)
  end

  private

  def self.exist_in_cache?(key)
    Rails.cache.exist?(key)
  end

  def self.get_cached_result(options)
    Rails.cache.fetch(options, expires_in: DEFAULT_CACHE_EXPIRATION_TIME) { self.get_json(options) }
  end

  def self.get_json(options)
    JSON.parse RestClient.get API_URL, {params: {appid: API_KEY, **options}}
  end
end