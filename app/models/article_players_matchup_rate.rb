class ArticlePlayersMatchupRate < ArticleItem
  
  def self.get_list_columns
    [:article_id]
  end
  
  def get_create_attributes
    [:article_id]
  end
  
  def get_update_attributes
    [:article_id]
  end
  
  def get_show_attributes
    [:article_id]
  end
  
end
