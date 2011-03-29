require 'digest/md5'

class User < ActiveRecord::Base
  
  belongs_to :user_type
  
  validates_format_of  :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "email address is invalid"    
  validates_uniqueness_of :email  
  
  attr_accessor :confirmation_password
  validates_confirmation_of :password
  
  def validate
    errors.add_to_base("Missing password" ) if hashed_password.blank?
  end
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)    
    if user
      expected_password = encrypted_password(password, user.salt)
      if ( user.hashed_password != expected_password ) || ( user.user_type.permission_level > 300 )
        user = nil
      end
    end
    user
  end
  
  # 'password' is a virtual attribute
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def get_create_attributes
    [:email, :user_type_id, :password, :confirmation_password]
  end
  
  def get_update_attributes
    [:email, :user_type_id, :password, :confirmation_password]
  end
  
  def get_show_attributes
    [:email, :user_type_id, :created_at, :updated_at]
  end
  
  def self.get_list_columns
    [:email, :updated_at, :user_type_id]
  end
  
  private
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "galimy" + salt # 'galimy' makes it harder to guess
    Digest::MD5.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
