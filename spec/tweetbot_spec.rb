require './tweetbot'
require 'pry-byebug'

describe PercentageCalculator do

  it "calculates the correct percentage of time elapsed" do
    calculator = PercentageCalculator.new(
      start_time: Time.new(2017, 1, 20, 12, 0, 0, "-05:00"),
      end_time: Time.new(2021, 1, 20, 12, 0, 0, "-05:00")
    )
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 21, 0, 0, 0, "-05:00").to_i
    }
    expect(calculator.percent).to eq(50.0)
  end

end


describe TweetComposer do

  it "composes a tweet correctly" do
    composer = TweetComposer.new(
      percent: 4.3,
      client: nil
    )
    expect(composer.full_tweet).to eq("The Trump presidency is 4.3% over. http://trumpexpirationdate.com")
  end

end


describe IntervalChecker do

  it "knows if it's at the right tweeting interval" do
    checker = IntervalChecker.new(
      percent: 4.4000123456,
    )
    expect(checker.correct_tweeting_interval?).to eq(true)
  end

  it "knows if it's not at the right tweeting interval" do
    checker = IntervalChecker.new(
      percent: 4.4351234567,
    )
    expect(checker.correct_tweeting_interval?).to eq(false)
  end

  it "knows if the percentage is below 0" do
    checker = IntervalChecker.new(
      percent: -1.4351234567,
    )
    expect(checker.correct_tweeting_interval?).to eq(false)
  end

  it "knows if the percentage is above 100" do
    checker = IntervalChecker.new(
      percent: 101.4351234567,
    )
    expect(checker.correct_tweeting_interval?).to eq(false)
  end

end


describe Tweeter do

  let(:fake_client)  { double(TwitterClient) }

  let (:start_time) { Time.new(2017, 1, 20, 12, 0, 0, "-05:00") }
  let (:end_time) { Time.new(2021, 1, 20, 12, 0, 0, "-05:00") }

  let (:calculator) { PercentageCalculator.new(
    start_time: start_time,
    end_time: end_time
  )}

  it "tweets if it's time" do
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 21, 0, 0, 0, "-05:00").to_i
    }
    tweeter = Tweeter.new(
      client: fake_client,
      percent: calculator.percent
    )
    expect(fake_client).to receive(:update).with("The Trump presidency is 50.0% over. http://trumpexpirationdate.com")
    tweeter.tweet_if_time
  end

  it "doesn't tweet if it's not time" do
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 23, 12, 0, 0, "-05:00").to_i
    }
    puts calculator.percent
    tweeter = Tweeter.new(
      client: fake_client,
      percent: calculator.percent
    )
    expect(fake_client).to_not receive(:update)
    tweeter.tweet_if_time
  end

  it "doesn't tweet if it's just before the right time" do
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 20, 23, 59, 59, "-05:00").to_i
    }
    tweeter = Tweeter.new(
    client: fake_client,
    percent: calculator.percent
    )
    expect(fake_client).to_not receive(:update)
    tweeter.tweet_if_time
  end

  it "tweets if it's just past the right time" do
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 21, 0, 15, 0, "-05:00").to_i
    }
    puts calculator.percent
    tweeter = Tweeter.new(
    client: fake_client,
    percent: calculator.percent
    )
    expect(fake_client).to receive(:update)
    tweeter.tweet_if_time
  end

end
