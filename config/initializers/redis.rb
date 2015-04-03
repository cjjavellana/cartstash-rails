require "redis"

$redis = Redis.new(:host => Rails.configuration.redis_url, :port => 6379)