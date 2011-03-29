class TeamDivision < ActiveRecord::Base
  
  has_many :team
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum=>255
  
  def to_label
    "#{name}"
  end
  
  def self.get_list_columns
    [:name]
  end
  
end