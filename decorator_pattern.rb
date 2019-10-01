# In object-oriented programming, the decorator pattern — is a design pattern that allows behavior to be added to an individual object, either statically or dynamically, without affecting the behavior of other objects from the same class. (Wikipedia)

class User
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

# A view wants the user's fullmname, decorator to the rescue by creating a decorated user
# out of the current user.
class DecoratedUser1
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end
end

# Usage

u = User.new("John", "Doe")
decorated_user = DecoratedUser1.new(u)

decorated_user.full_name # => John Doe

# but decorator should have existing methods of object as well
# i.e keep behaviour of user plus additional behaviours it is adding

# RUby's forwadable module to the rescue

require 'forwardable'

class DecoratedUser2
  extend Forwardable
  # a call for first_name and last_name should be send to @user object
  def_delegators :@user, :first_name, :last_name

  def initialize(user)
    @user = user
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

u = User.new("John", "Doe")
decorated_user = DecoratedUser2.new(u)

decorated_user.full_name # => John Doe
# call is made to @user.first_name
decorated_user.first_name # => John
decorated_user.last_name # => Doe

# using SimpleDelegator

require 'delegate'
class DecoratedUser3 < SimpleDelegator
  def full_name
    "#{first_name} #{last_name}"
  end
end

u = User.new("John", "Doe")
decorated_user = DecoratedUser3.new(u)
#  On each method call Ruby tries to find it in current class (DecoratedUser)
# and if there is no such method - it tries to find that
# method in object we passed on initialization (User).
decorated_user.full_name # => John Doe
decorated_user.first_name # => John
decorated_user.last_name # => Doe