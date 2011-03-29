class Language < ActiveRecord::Base
  
  validates_presence_of :name, :abbreviation
  validates_uniqueness_of :name, :abbreviation
  validates_length_of :abbreviation, :maximum=>3
  validates_length_of :name, :maximum=>255
  
  def to_label
    "#{name} (#{abbreviation})"
  end
  
  def self.get_list_columns
    [:name, :abbreviation]
  end
  
end
