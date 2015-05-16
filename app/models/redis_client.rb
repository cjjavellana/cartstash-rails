#
# A wrapper class for $redis from the gem redis-rb
#
class RedisClient

  #
  # Stores a non-expiring key-pair into redis
  #
  # @key - A string, the cache key
  # @value - A string, the value to store
  def self.set(key, value)
    $redis.set key, value
  end

  #
  # Stores a key-value pair into redis that will expire after a specified
  # amount of time.
  #
  # @key - A string, the cache key
  # @value - A string, the value to to store
  # @expiry - A fixnum, default of 86400 (1 day)
  def self.set_with_expiry(key, value, expiry = 86400)
    $redis.set(key, value, {:ex => expiry})
  end

  #
  # Retrieves a value from the cache
  #
  # @key - A string, the key that identifies the value to retrieve
  def self.get(key)
    begin
      $redis.get key
    rescue Redis::CannotConnectError
      nil
    end
  end

  #
  # Deletes a value from the cache
  #
  # @key - A string, the key that identifies the value to delete
  def self.delete(key)
    $redis.del key
  end

  #
  # Returns the cache keys which matches the given pattern
  #
  # @pattern - The key pattern to retrieve
  def self.keys(pattern = "*")
    $redis.keys(pattern)
  end
end