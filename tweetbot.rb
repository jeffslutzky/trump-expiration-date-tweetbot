require 'twitter'
require 'dotenv'
require 'pry-byebug'
Dotenv.load


class TwitterClient

  attr_accessor :client

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

end


class Tweeter

  attr_reader :client, :percent, :tweet_composer, :interval_checker

  def initialize(args)
    @client = args[:client] ||= TwitterClient.new.client
    @percent = args[:percent]
    @tweet_composer = args[:tweet_composer] ||= TweetComposer.new(percent: @percent)
    @interval_checker = args[:interval_checker] ||= IntervalChecker.new(percent: @percent)
  end

  def tweet_if_time
    if interval_checker.correct_tweeting_interval?
      tweet
    else
      puts "It's not time to tweet."
    end
  end

  private

    def tweet
      client.update(tweet_composer.full_tweet)
      puts "Tweeted '#{tweet_composer.full_tweet}'"
    end

end


class PercentageCalculator

  attr_accessor :start_time, :end_time

  def initialize(args)
    @start_time = args[:start_time]
    @end_time = args[:end_time]
  end

  def percent
    elapsed_time/total_time.to_f * 100
  end

  private

    def total_time
      end_time.to_i - start_time.to_i
    end

    def now
      Time.now.to_i
    end

    def elapsed_time
      now - start_time.to_i
    end

end




class IntervalChecker

  attr_reader :percent

  def initialize(args)
    @percent = args[:percent]
  end

  def correct_tweeting_interval?
    percent.between?(0, 100.05) &&
    (percent * 1000).to_i % 100 == 0
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
