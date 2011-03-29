class TeamItem < ActiveRecord::Base
  
  belongs_to :language
  belongs_to :team
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum=>255
  
  def to_label
    "Team item: #{name} "
  end
  
  def self.get_list_columns
    [:name, :language_id, :team_id]
  end
  
end
