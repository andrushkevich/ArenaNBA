class Game < ActiveRecord::Base
  
  after_save :save_article
  after_create :save_article
  after_update :save_article
  before_create :set_current_season


    
  belongs_to :team_home,
    :class_name => "Team",
    :foreign_key => "team_home_id"    
  belongs_to :team_guest,
    :class_name => "Team",
    :foreign_key => "team_guest_id"
  belongs_to :season_id
  belongs_to :winner_type
  has_one :article
  
  validates_numericality_of :period_first_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_first_guest, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_second_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_second_guest, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_third_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_third_guest, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_fourth_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :period_fourth_guest, :only_integer => true, :allow_nil => true
  validates_numericality_of :total_over_time_guest, :only_integer => true, :allow_nil => true
  validates_numericality_of :total_over_time_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :total_home, :only_integer => true, :allow_nil => true
  validates_numericality_of :total_guest, :only_integer => true, :allow_nil => true
  
  def self.current_season_id(team_type_id)
    team_type_id == 1 ? 4 : 3
  end  

  def to_label
    "#{date.to_s} #{team_home.name} @ #{team_guest.name}"
  end
  
  def to_s(lang=nil)
    "#{team_guest.current_name(lang)} @ #{team_home.current_name(lang)}"
  end
  
  def score_to_s
    ( total_guest && total_home ) ? "#{total_guest}:#{total_home}" : "---"
  end
  
  def save_article
    related_article = self.article || Article.new
    related_article.name = "#{self.to_label} --(#{self[:id] || "new"})"
    self.article = related_article
    self.article.save
  end
  
  def before_destroy
    self.article.destroy
  end

  def set_current_season
    self["season_id"] = Game.current_season_id(team_home.team_type["id"])
  end
  
  def get_create_attributes
    [:date, :team_guest_id, :team_home_id, :winner_type_id, :difference, :edge, :period_first_guest, :period_first_home,
      :period_second_guest, :period_second_home, :period_third_guest, :period_third_home,
      :period_fourth_guest, :period_fourth_home, :total_over_time_guest, :total_over_time_home,
      :total_guest, :total_home ]
  end
  
  def get_update_attributes
    [:date, :team_guest_id, :team_home_id, :winner_type_id, :difference, :edge, :period_first_guest, :period_first_home,
      :period_second_guest, :period_second_home, :period_third_guest, :period_third_home,
      :period_fourth_guest, :period_fourth_home, :total_over_time_guest, :total_over_time_home,
      :total_guest, :total_home ]
  end
  
  def get_show_attributes
    [:date, :team_guest_id, :team_home_id, :winner_type_id, :difference,  :edge, :period_first_guest, :period_first_home,
      :period_second_guest, :period_second_home, :period_third_guest, :period_third_home,
      :period_fourth_guest, :period_fourth_home, :total_over_time_guest, :total_over_time_home,
      :total_guest, :total_home ]
  end
  
  def self.get_list_columns
    [:date, :team_guest_id, :team_home_id, :winner_type_id, :difference,  :edge]
  end
  
  def self.team_home_id_order
    "name"
  end
  
  def self.team_guest_id_order
    "name"
  end
  
  
end
