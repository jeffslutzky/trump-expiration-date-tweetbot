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
    # Time.new(2017, 1, 20, 17, 0, 0).to_i #UTC
    # Time.new(2015,1,19,23).to_i
    Time.new(2015,1,17,0,12,36,"-05:00").to_i

  end

  def finish
    # Time.new(2021, 1, 20, 17, 0, 0).to_i #UTC
    # Time.new(2019,1,19,23).to_i
    Time.new(2019,1,17,0,12,36,"-05:00").to_i
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

  def tweet_sentence(percent)
    "[testing] We're #{percent.round(1).to_s}% done with the T---p presidency."
  end

  def url
    "http://trumpexpirationdate.com"
  end

  def full_tweet
    "#{tweet_sentence(percent)} #{url}"
  end

  def check
    puts "Currently at #{percent}%."
    if (percent * 1000).to_i % 100 == 0 && !client.user_timeline.first.text.include?(tweet_sentence(percent))
      client.update(full_tweet)
      puts "Tweeted '#{full_tweet}'"
    else
      puts "It's not time to tweet."
    end
  end

end
