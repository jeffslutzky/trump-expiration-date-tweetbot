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
    # Time.new(2009,1,20,12).to_i
    Time.new(2015,1,19,11).to_i

  end

  def finish
    # Time.new(2017,1,20,12).to_i
    Time.new(2019,1,19,11).to_i
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
    "[testing] We're #{percent.round(1).to_s}% done with the T---p presidency. http://trumpexpirationdate.com"
  end

  def check
    puts "Currently at #{percent}%."
    if (percent * 1000).to_i % 100 == 0 && client.user_timeline.first.text != tweet(percent)
      client.update(tweet(percent))
      puts "Tweeted '#{tweet(percent)}'"
    else
      puts "It's not time to tweet."
    end
  end

end
