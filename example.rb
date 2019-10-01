# frozen_string_literal: true

module Wrapper
  # A factory object is an object that exists for the sole purpose of creating other objects.
  def self.person(**args)
    ThirdParty::Person.new(args[:first_name], args[:last_name], args[:age])
  end
end

class Example
  # In the code, the Wrapper module is a factory object.
  # It’s sole purpose is to initialize a new Person object. But it does so in a special way,
  # it doesn’t just mimic Person’s initializer. It creates a different way to initialize a new Person object.
  def initialize
    @person = ::Wrapper.person(first_name: 'John', last_name: 'Doe', age: 23)
  end
end
