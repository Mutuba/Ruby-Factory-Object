class Product
  class << self
    [:name, :brand].each do |attribute|
      define_method :"find_by_#{attribute}" do |value|
        all.find {|prod| prod.public_send(attribute) == value }
      end
    end
  end
end

#same as

class Product
  def self.find_by_name(value)
    all.find {|prod| prod.name == value }
  end

  def self.find_by_brand(value)
    all.find {|prod| prod.brand == value }
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
          self.status == User.const_get(arg.upcase)
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

buddy = Alpaca.new("Buddy", 24)
# Let's call our methods and make sure they return what we expect
puts buddy.name # Buddy
puts buddy.age # 24

# Let's see if our object responds to the new methods we created
puts buddy.respond_to?(:name) # true
puts buddy.respond_to?(:name=) # true