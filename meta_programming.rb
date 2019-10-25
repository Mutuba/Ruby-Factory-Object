# frozen_string_literal: true

class Product
  class << self
    %i[name brand].each do |attribute|
      define_method :"find_by_#{attribute}" do |value|
        all.find { |prod| prod.public_send(attribute) == value }
      end
    end
  end
end

# same as

class Product
  def self.find_by_name(value)
    all.find { |prod| prod.name == value }
  end

  def self.find_by_brand(value)
    all.find { |prod| prod.brand == value }
  end
end

class User
  ACTIVE = 0
  INACTIVE = 1
  PENDING = 2

  attr_accessor :status

  def self.states(*args)
    args.each do |arg|
      define_method "#{arg}?" do
        status == User.const_get(arg.upcase)
      end
    end
  end
end

User.states('active', 'inactive', 'pending')
u = User.new
u.status = 0

p u.active? # true

# example
# Let's create a base class to extend from.
# This class contains the code generator methods that we'll be using.
class Base
  def self.getset(*args)
    args.each do |field|
      getter(field)
      setter(field)
    end
  end

  def self.getter(*args)
    args.each do |field|
      define_method(field) do
        instance_variable_get("@#{field}")
      end
    end
  end

  def self.setter(*args)
    args.each do |field|
      define_method("#{field}=") do |value|
        instance_variable_set("@#{field}", value)
      end
    end
  end
end

# Now let's create a class and utilize our getset generator
class Alpaca < Base
  # We'll create accessors for :name and :age
  getset :name, :age

  def initialize(name, age)
    self.name = name
    self.age  = age
  end
end

buddy = Alpaca.new('Buddy', 24)
# Let's call our methods and make sure they return what we expect
puts buddy.name # Buddy
puts buddy.age # 24

# Let's see if our object responds to the new methods we created
puts buddy.respond_to?(:name) # true
puts buddy.respond_to?(:name=) # true

# example

class Navigation
  FIRST_ROLE = %w[settings messages groups music news].freeze
  SECOND_ROLE = %w[settings messages].freeze

  def set_current_user(current_user)
    @current_user = current_user
  end

  def create_methods
    current_user_ui_elements.each do |ui_element|
      self.class.send(:define_method, "display_#{ui_element}") { puts "Code for displaying #{ui_element}" }
    end
  end

  def display_all_nav_elements
    current_user_ui_elements.each do |ui_element|
      public_send("display_#{ui_element}")
    end
  end

  private

  def current_user_ui_elements
    Navigation.const_get(@current_user[:role])
  end
end

current_user = { name: 'Alex', role: 'FIRST_ROLE' }
new_navigation = Navigation.new
new_navigation.set_current_user(current_user)
new_navigation.create_methods
new_navigation.display_all_nav_elements

# output
# Code for displaying settings
# Code for displaying messages
# Code for displaying groups
# Code for displaying music
# Code for displaying news
# => ["settings", "messages", "groups", "music", "news"]

# Memoize
class ShowPresenter
  extend ActiveSupport::Memoizable

  def initialize(tweet)
    @tweet = tweet
  end

  def username
    @tweet.user.username
  end

  def status
    @tweet.status
  end

  def favorites_count
    @tweet.favorites.count
  end

  memoize :username, :status, :favorites_count
end

# my_xbonacci([1,1,1,1], 6)
# signature.length

# a=["dan", "mutuba", "deno"]
# b= ["dan", "mutuba", "deno", "njeri"]

# def merger(arr1,arr2)
# merged_arr = {}.tap { |hash| (arr1 + arr2).each { |el| hash[el] ||= el } }.keys
# end

# p merger(a,b)
ha = {}

[1, 2, 3, 4, 4, 5, 5, 7, 7, 8].each { |el| ha[el] ||= el }
p ha
