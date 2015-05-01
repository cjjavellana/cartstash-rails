class RedisClient

  def self.set(key, value)
    $redis.set key, value
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