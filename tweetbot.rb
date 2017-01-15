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
    # have to fix so it doesn't miss one since it only runs every 10 minutes
    # "The Trump presidency is #{percent.round(6).to_s}% over. [URL]"
    "test"
  end

  def check
    puts "Currently at #{percent}%."
    # if (percent * 10) % 5 == 0 # 0.5, 1.0, 1.5, etc.
      client.update(tweet(percent))
      puts "Tweeted '#{tweet(percent)}'"
    # end
  end

end
