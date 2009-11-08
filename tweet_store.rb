require 'json'
require 'redis'
require File.join(File.dirname(__FILE__), 'tweet')

class TweetStore
  
  REDIS_KEY = 'tweets'
  NUM_TWEETS = 20
  TRIM_THRESHOLD = 100
  
  def initialize
    @db = Redis.new
    @trim_count = 0
  end
  
  # Retrieves the specified number of tweets, but only if they are more recent
  # than the specified timestamp.
  def tweets(limit=15, since=0)
    @db.list_range(REDIS_KEY, 0, limit - 1).collect {|t|
      Tweet.new(JSON.parse(t))
    }.reject {|t| t.received_at <= since}  # In 1.8.7, should use drop_while instead
  end
  
  def push(data)
    @db.push_head(REDIS_KEY, data.to_json)
  
    @trim_count += 1
    if (@trim_count > 100)
      # Periodically trim the list so it doesn't grow too large.
      @db.list_trim(REDIS_KEY, 0, NUM_TWEETS)
      @trim_count = 0
    end
  end
  
end
