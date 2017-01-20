require 'twitter'
require 'dotenv'
Dotenv.load

class TrumpPercentageChecker

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def start
    Time.new(2017, 1, 20, 12, 0, 0, "-05:00").to_i
  end

  def finish
    Time.new(2021, 1, 20, 12, 0, 0, "-05:00").to_i
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
    "The Trump presidency is #{percent.round(1).to_s}% over."
  end

  def url
    "http://trumpexpirationdate.com"
  end

  def full_tweet
    "#{tweet_sentence(percent)} #{url}"
  end

  def correct_tweeting_interval?(percent)
    (percent * 1000).to_i % 100 == 0
  end

  def unique_tweet?(tweet_sentence)
    !client.user_timeline.first || !client.user_timeline.first.text.include?(tweet_sentence(percent))
  end

  def check
    if now >= start && now <= finish
      puts "Currently at #{percent}%."
      if correct_tweeting_interval?(percent) && unique_tweet?(tweet_sentence(percent))
        client.update(full_tweet)
        puts "Tweeted '#{full_tweet}'"
      elsif correct_tweeting_interval?(percent) && !unique_tweet?(tweet_sentence(percent))
        puts "I'd tweet, but this percentage was already tweeted."
      else
        puts "It's not time to tweet."
      end
    end
  end

end
