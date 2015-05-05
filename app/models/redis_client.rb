class RedisClient

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
  # @key - A string, the key which identifies the value to retrieve
  def self.get(key)
    $redis.get key
  end

  def self.delete(key)
    $redis.del key
  end

  def self.keys(pattern = "*")
    $redis.keys(pattern)
  end
end