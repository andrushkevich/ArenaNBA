class Setting < ActiveRecord::Base
  
  validates_uniqueness_of :key
  validates_presence_of :key
  validates_length_of :key, :maximum=>255
  validates_length_of :value, :maximum=>4000
  
  def to_label
    "#{key} "
  end
  
  def self.get_list_columns
    [:key]
  end
  
end
