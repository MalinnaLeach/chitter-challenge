require 'dm-postgres-adapter'
require 'data_mapper'
require_relative 'datamapper_setup'
require_relative 'peep'

class User
  include DataMapper::Resource
  #include BCrypt

  def self.login_check(username)
    if self.first(username: username).nil?
      @redirect = '/failed-login'
      return nil
    else
      @redirect = '/home'
      return username
    end
  end

  def self.redirect
    @redirect
  end

  def self.new_user_create(name, username, email, password)
    @redirect = '/home'
    if !User.first(email: email).nil?
      @redirect = '/re-login'
    elsif !User.first(username: username).nil?
      @redirect = '/re-signup/' + "#{username}"
    else
      self.create(name: name, username: username, email: email, password: password)
    end
  end

  property :id, Serial
  property :name, String
  property :username, String, :unique => true
  property :email, String, :unique => true
  property :password, String

  has n, :peeps


  # def encrypt_password(password)
  #     BCrypt::Password.create(password.to_s)
  # end

  # has n, :links, :through => Resource
  # has n, :tags, :through => Resource
end
