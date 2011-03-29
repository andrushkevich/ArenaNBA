class PlayerPosition < ActiveRecord::Base
  has_many :player
  
  validates_uniqueness_of :name
  validates_presence_of :name
end