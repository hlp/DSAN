# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  access_code        :string(255)
#

require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt;

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :access_code

  has_many :ds_modules, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  validate :has_valid_code, :on => :create

  before_save :encrypt_password

  default_scope :order => 'users.name ASC'

  # return true if the user's password matches the submitted password
  # note that BCrypt casts the submitted_password into a 
  # BCrypt::Password object (it's not doing a string compare)
  def has_password?(submitted_password)
    BCrypt::Password.new(self.encrypted_password) == submitted_password
  end

  def self.authenticate(email, submitted_password)
    user = User.find_by_email_insensitive(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private
  
  def encrypt_password
    # unfortunately BCrypt-ruby doesn't allow you to use your own salts
    # though we still make one as we use it for the cookies in 
    # session authentication
    self.salt = make_salt if new_record?

    # this has a work level of 10 by default
    # and automatically makes organic shade-grown caspian sea salt
    self.encrypted_password = BCrypt::Password.create(password).to_s
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

 # assign them a random one and mail it to them, asking them to change it
  def self.forgot_password(user_email)
    @user = User.find_by_email_insensitive(user_email)
    return false unless @user
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.password = random_password
    @user.save!
    Notifier.password_change(@user, random_password).deliver
    return true
  end

  def has_valid_code
    creation_key = Creationkey.find_by_key(self.access_code)

    unless creation_key
      errors.add("Access code", "is invalid.")
      return false
    end

    creation_key.destroy
    return true
  end

  def self.find_by_email_insensitive(em)
    User.all.each do |u|
      if u.email.downcase == em.downcase
        return u
      end
    end

    return nil
  end

end
