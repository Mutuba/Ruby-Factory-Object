# frozen_string_literal: true

# Example1

class ResponseHandler
  attr_reader :response

  def self.show(response)
    @strategies = {}
    @strategies[:success] = -> { 'Successful response:' }
    @strategies[:error] = -> { 'Error: An implementation for strategies' }
    @strategies[:fail] = -> { 'Request Failed .What a cleaner way to avoid ifs' }
    strategy = @strategies[response.to_sym]
    strategy ? strategy.call : response
  end
end

def my_response
  response = 'error' # a response could be a call to an API,
  # or an active record query
  ResponseHandler.show(response)
end
my_response

# Example 2

class Taxes
  attr_reader :amount

  def initialize(amount)
    @amount = amount

    @strategies = {}
    @strategies['Ukraine'] = -> { (amount * 0.05) + 313 }
    @strategies['Poland'] = -> { amount * 0.3 }
    @strategies['U.S.'] = -> { (amount * 0.2) + 100 }
  end

  def net_salary(country)
    strategy = @strategies[country]

    strategy ? amount - strategy.call : amount
  end
end

Taxes.new(1200).net_salary('U.S.') # => 700.0


# Example3


class ResponseHandler
  def self.handle(response, strategies)
    strategies[response.status.to_sym].call
  end
end

def show
  response = external_service.get(params[:id])

  on_success = -> { "Successful response: #{response.data}" }
  on_error = -> { "Error: #{response.error_message}" }
  on_fail = -> { "Request Failed" }

  ResponseHandler.handle(response, success: on_success, error: on_error, fail: on_fail)
end