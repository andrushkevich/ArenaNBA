class SitemapController < ApplicationController  
  
  def xml    
    @article_item = ArticleItem.find(:all)
    @content = Content.find(:all) 
    @language = Language.find(:all)
    @start_date = Date.new(2008, 11, 9)
    @players = Player.find(:all)
    @teams = Team.find(:all)
    render :content_type => "application/xml"        
  end
  
end
