class Team < ActiveRecord::Base
  
  has_many :team_items
  has_many :players
  belongs_to :team_type
  belongs_to :team_division
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum=>255
  
    
  file_column :image_file_column,
    :magick=>{:size=>"150x100",:versions=>{:thumb=>"58x55"}}
  
  validates_file_format_of :image_file_column, :in=>["jpeg","jpg","png", "gif","bmp"]
  validates_filesize_of :image_file_column, :in => 1.kilobytes..500.kilobytes
  
  def to_label
    "#{name} (#{team_type.name})"
  end
  
  def self.get_list_columns
    [:name, :image_file_column, :team_division_id, :team_type_id]
  end
  
  def current_name(lang=nil)
    lang ? TeamItem.find_by_team_id_and_language_id(id,lang[:id]).name : name
  end
  
  def current_abbreviation(lang=nil)
    lang ? TeamItem.find_by_team_id_and_language_id(id,lang[:id]).abbreviation : name
  end
  
end
