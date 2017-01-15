require 'twitter'
require 'dotenv'
Dotenv.load

class TrumpRegressBar

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def start
    Time.new(2009,1,20,12).to_i
  end

  def finish
    Time.new(2017,1,20,12).to_i
  end

  def total
    finish - start
  end

  def now
    Time.now.to_i
  end

  def elapsed
    now - start
  end

  def percent
    elapsed/total.to_f * 100
  end

  def tweet(percent)
    "The Trump presidency is #{percent.round(1).to_s}% over!"
  end

  def check
    puts percent
    puts (percent * 10) % 1
    
    # if (percent * 10) % 1 == 0
      # i.e. if it's a multiple of 0.5 percent - 0.5, 1.0, 1.5...
      client.update(tweet(percent))
    # end
  end

end
