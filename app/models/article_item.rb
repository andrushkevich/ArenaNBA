class ArticleItem < ActiveRecord::Base  
  
  belongs_to :article  
  belongs_to :language  
  belongs_to :article_type
  
  validates_length_of :meta_title, :maximum => 300, :allow_blank=>true
  validates_length_of :meta_keywords, :maximum => 300, :allow_blank=>true
  validates_length_of :meta_description, :maximum => 300, :allow_blank=>true  
  
  def to_label
    "#{meta_title} "
  end
  
  def before_create
    game = Article.find(article_id).game
    home_team = TeamItem.find_by_team_id_and_language_id(game.team_home_id, language_id)
    guest_team = TeamItem.find_by_team_id_and_language_id(game.team_guest_id, language_id)
    set_meta_info("meta_title", game, guest_team, home_team)
    set_meta_info("meta_description", game, guest_team, home_team)
    set_meta_info("meta_keywords", game, guest_team, home_team)
  end
  
  private
  
  def set_meta_info(field, game, guest_team, home_team)
    if self[field].blank?
      template = Setting.find_by_key "#{field}_template_#{self.language.abbreviation}"
      if template
        input = template.value
        input = input.gsub('$HTA', home_team.abbreviation).gsub('$GTA', guest_team.abbreviation)
        input = input.gsub('$HT', home_team.name).gsub('$GT', guest_team.name)
        input = input.gsub('$D', game.date.strftime("%Y-%m-%d"))
        if self.language.abbreviation == 'en'
          input = input.gsub('$TY', article_type.name)
        else
          input = input.gsub('$TY', ( ( article_type.name == 'matchup')?("Прогноз"):("Обзор")))
        end
        self[field] = input
      end
    end
  end
  
end