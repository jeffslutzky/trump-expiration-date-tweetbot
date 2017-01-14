gem 'twitter'
require 'twitter'
require "./client.rb"

class TrumpRegressBar

  def client
    Client.new.client
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
    "The Trump presidency is #{percent.round(5).to_s}% over."
  end

  def check
    # if (percent * 10) % 5 == 0
      # it's a multiple of 0.5 percent - 0.5, 1.0, 1.5...
      client.update(tweet(percent))
    # end
  end

  # client.update(tweet(percent))

end

tweeter = TrumpRegressBar.new
tweeter.check
