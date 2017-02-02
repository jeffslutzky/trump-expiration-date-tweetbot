require './tweetbot'


describe PercentageCalculator do

  it "calculates the correct percentage of time elapsed" do
    calculator = PercentageCalculator.new(
      start_time: Time.new(2017, 1, 20, 12, 0, 0, "-05:00").to_i,
      end_time: Time.new(2021, 1, 20, 12, 0, 0, "-05:00").to_i
    )
    allow(calculator).to receive(:now) {
      Time.new(2019, 1, 21, 0, 0, 0, "-05:00").to_i
    }
    expect(calculator.percent).to eq(50.0)
  end

end


describe TweetComposer do

  it "composes a tweet correctly" do
    composer = TweetComposer.new(percent: 4.3)
    expect(composer.full_tweet).to eq("The Trump presidency is 4.3% over. http://trumpexpirationdate.com")

  end
end


describe IntervalChecker do

  it "knows if it's not time to tweet" do
    checker = IntervalChecker.new(
    percent: 4.4351234567,
    client: TwitterClient.new
    )
    expect(checker.correct_tweeting_interval?).to eq(false)
  end

  it "knows if it's time to tweet" do
    checker = IntervalChecker.new(
      percent: 4.4001234567,
      client: TwitterClient.new
    )
    expect(checker.correct_tweeting_interval?).to eq(true)
  end


  it "knows if a potential tweet isn't unique" do
    checker = IntervalChecker.new(
      percent: 4.300000567,
      client: TwitterClient.new
    )
    require 'pry-byebug'
    binding.pry
    checker.client.user_timeline.first = "The Trump presidency is 4.3% over. http://trumpexpirationdate.com"
    expect(checker.unique_tweet?).to eq(true)
  end

end
