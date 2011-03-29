class Player < ActiveRecord::Base
  
  belongs_to :player_position
  belongs_to :team
  has_one :ru_player
  
  validates_numericality_of :height
  validates_numericality_of :weigh
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  file_column :image_file_column,
    :magick=>{ :size=>"65x90", :versions => { :thumb=>"30x30" } }
  
  def to_label
    "#{first_name} #{last_name}"
  end
  
  def self.get_list_columns
    [:first_name, :last_name, :team_id]
  end
  
  def current_first_name(lang)
    (lang && lang.abbreviation == 'ru' && ru_player && !ru_player.first_name.blank? )?(ru_player.first_name):(first_name)
  end
  
  def current_last_name(lang)
    (lang && lang.abbreviation == 'ru' && ru_player && !ru_player.last_name.blank? )?(ru_player.last_name):(last_name)
  end
  
  def current_to_label(lang)
    "#{current_first_name(lang)} #{current_last_name(lang)}"
  end
  
end