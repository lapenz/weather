class WeatherGetter
  API_KEY = 'e155ba888319d33e0b85dec3fa93ef64'
  API_URL = "https://api.openweathermap.org/data/2.5/weather"
  DEFAULT_CACHE_EXPIRATION_TIME = 30.minutes
  DEFAULT_OPTIONS = {appid: API_KEY, units: 'metric'}

  def self.call(searchKey, searchValue, cache_expiration_time = DEFAULT_CACHE_EXPIRATION_TIME, options = DEFAULT_OPTIONS)
    return OpenStruct.new(success?: true) if searchValue.blank?
    options[searchKey] = searchValue
    OpenStruct.new(success?: true,
                   cache_data?: exist_in_cache?(options),
                   result: get_cached_result(cache_expiration_time, options))
  rescue => e
    OpenStruct.new(success?: false, error: e.message)
  end

  def self.get_by_zipcode(zipcode)
    self.call(:zip, zipcode)
  end

  private

  def self.exist_in_cache?(key)
    Rails.cache.exist?(key)
  end

  def self.get_cached_result(cache_expiration_time, options)
    Rails.cache.fetch(options, expires_in: cache_expiration_time) { self.get_json(options) }
  end

  def self.get_json(options)
    JSON.parse RestClient.get API_URL, {params: {**options}}
  end
end