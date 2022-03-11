# Services classes is a very important and well known design pattern which allow us to separate business logic
# from the controller layer. By doing this, the logic here can be reused in many different places and also become much
# easier to test and maintain the code, since its more modular and decoupled.
class CacheManager
  # It's possible to disable the cache adding 0 to the expiration envar
  DEFAULT_CACHE_EXPIRATION_TIME = ENV['CACHE_EXPIRATION_LIMIT_IN_MINUTES'].to_i.minutes

  # Responsible for pulling data from Cache if possible, otherwise call the method.
  # If we need to change the way we cache things we can easily change the logic inside these methods here and no
  # modification would be necessary inside the classes that use them.
  def self.get_value(key, &method)
    Rails.cache.fetch(key, expires_in: DEFAULT_CACHE_EXPIRATION_TIME) { method.call(key) }
  end

  # Check if a specific value is already cached
  def self.exist_in_cache?(key)
    Rails.cache.exist?(key)
  end
end