# frozen_string_literal: true

# class A
#   class << self
#     def class_name
#       to_s
#     end
#   end
# end
# A.define_singleton_method(:who_am_i) do
#   "I am: #{class_name}"
# end
# A.who_am_i   # ==> "I am: A"

# guy = "Bob"
# guy.define_singleton_method(:hello) { "#{self}: Hello there!" }
# guy.hello    #=>  "Bob: Hello there!"

# define_singleton_method(:my_puts2) {|x| puts x}
# my_puts2 45

require 'observer'

class Ticker
  ### Periodically fetch a stock price.
  include Observable

  def initialize(symbol)
    @symbol = symbol
  end

  def run
    last_price = nil
    loop do
      price = Price.fetch(@symbol)
      print "Current price: #{price}\n"
      if price != last_price
        changed # notify observers
        last_price = price
        notify_observers(Time.now, price) # calls update
      end
      sleep 1
    end
  end
end

class Price
  ### A mock class to fetch a stock price (60 - 140).
  def self.fetch(_symbol)
    rand(60..139)
  end
end

class Warner ### An abstract observer of Ticker objects.
  def initialize(ticker, limit)
    @limit = limit
    ticker.add_observer(self)
  end
end

class WarnLow < Warner
  def update(time, price) # callback for observer
    print "--- #{time}: Price below #{@limit}: #{price}\n" if price < @limit
  end
end

class WarnHigh < Warner
  def update(time, price) # callback for observer
    print "+++ #{time}: Price above #{@limit}: #{price}\n" if price > @limit
  end
end

ticker = Ticker.new('MSFT')
WarnLow.new(ticker, 80)
WarnHigh.new(ticker, 120)
ticker.run
