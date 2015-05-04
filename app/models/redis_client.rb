class RedisClient

  def self.set(key, value)
    $redis.set key, value
  end

  def self.set_with_expiry(key, value, expiry = 86400)
    $redis.set(key, value, {:ex => expiry})
  end

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