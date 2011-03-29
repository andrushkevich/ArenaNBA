class WinnerType < ActiveRecord::Base
  has_many :game
  has_many :player_game
  
  validates_uniqueness_of :name
  validates_length_of :name, :maximum=>255    
end