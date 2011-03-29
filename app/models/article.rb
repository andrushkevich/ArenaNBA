class Article < ActiveRecord::Base
  
  belongs_to:game
  validates_uniqueness_of :name
  validates_length_of :name, :maximum=>255  
  
  def to_label
    "#{name} "
  end
end