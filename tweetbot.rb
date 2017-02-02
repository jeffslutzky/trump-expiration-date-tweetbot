require 'twitter'
require 'dotenv'
Dotenv.load


class TwitterClient

  def initialize
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

end




class PercentageCalculator

  attr_accessor :start_time, :end_time

  # start_time
  #   Time.new(2017, 1, 20, 12, 0, 0, "-05:00").to_i
  #
  # end_time
  #   Time.new(2021, 1, 20, 12, 0, 0, "-05:00").to_i

  def initialize(args)
    @start_time = args[:start_time]
    @end_time = args[:end_time]
  end

  def percent
    elapsed_time/total_time.to_f * 100
  end

  private

    def total_time
      end_time - start_time
    end

    def now
      Time.now.to_i
    end

    def elapsed_time
      now - start_time
    end

end




class TweetComposer

  attr_reader :percent

  def initialize(args)
    @percent = args[:percent]
  end

  def full_tweet
    "#{tweet_sentence(percent)} #{url}"
  end

  private

    def tweet_sentence(percent)
      "The Trump presidency is #{percent.round(1)}% over."
    end

    def url
      "http://trumpexpirationdate.com"
    end

end




class IntervalChecker

  attr_reader :percent, :client

  def initialize(args)
    @percent = args[:percent]
    @client = args[:client]
  end

  def correct_tweeting_interval?
    (percent * 1000).to_i % 100 == 0
  end

  def unique_tweet?(tweet_sentence)
    !client.user_timeline.first.text.include?(tweet_sentence(percent || !client.user_timeline.first))
  end

  def check
    if now >= start_time && now <= end_time
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
