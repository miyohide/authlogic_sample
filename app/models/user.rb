class User < ActiveRecord::Base
  attr_accessible :name, :email, :login, :password, :password_confirmation
  acts_as_authentic do |c|
    c.login_field = 'email'
  end
end
