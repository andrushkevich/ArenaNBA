module FrontHelper
  
  #return a meta tag for spesial field by object
  def meta_field_content_for(field, *args)
    output= ""
    args.each do |object|
      if object
        meta = object.is_a?(MetaInfo) ? object : MetaInfo.bind_from_object(object)
        output<<meta.send(field)<<" " if meta.send(field)
      end
    end  
    if output.empty?
      output<<Setting.find_by_key("home_#{field.to_s}_" + @lang.abbreviation).value
    end
    output
  end
  
  #return imgage tag for given image
  def img_team_tag_for(team)
    output=""
    output<<team.id.to_s<<"/thumb/"<<team.image.to_s    
    %Q{<img src="team/image/#{output}" width="58" height="55" />}
  end
  
  #get name of team on current language
  def name_of_team(team)
    TeamItem.find_by_team_id_and_language_id(team[:id], @lang[:id]).name
  end
  
  
  #return span tag with game score for index page
  def score_sum_tag(game, is_home)
    output="scores_sum"
    if game.total_home != nil && game.total_guest != nil      
      if is_home
        if game.total_home > game.total_guest
          output<<"_win"
        end
        %Q{<span class="#{output}">#{game.total_home}</span>}
      else
        if game.total_home < game.total_guest
          output<<"_win"
        end
        %Q{<span class="#{output}">#{game.total_guest}</span>}
      end
    else
      %Q{<span class="scores_sum">&nbsp;</span>}
    end    
  end
  
  
  # Returns meta title tag for given objects if they have meta_title method
  def meta_title_for(*args)
    output=""
    args.each do |object|
      if object && object.respond_to?(:meta_title)
        output<<object.meta_title<<" " if object.meta_title        
      end      
    end
    if output.empty?
      output<<Setting.find_by_key("home_meta_title_" + @lang.abbreviation).value
    end
    %Q{<title>#{output}</title>}
  end
  
  # Returns meta description tag for given objects if they have meta_description methods
  def meta_description_for(*args)
    output=""
    args.each do |object|
      if ( object &&   ( object.respond_to? :meta_description) )
        output<<object.meta_description<<" "  if object.meta_description
      end      
    end
    if output.empty?
      output<<Setting.find_by_key("home_meta_description_" + @lang.abbreviation).value
    end
    %Q{<meta name="description" content="#{output}"/>}
  end

  #Returt a link tag for article page on game score control
  def link_for_article(game, is_index, content = nil , css_class = nil)
    output=""
    if is_index && game
      article_item = ArticleItem.find_by_article_id_and_language_id_and_article_type_id(game.article[:id], @lang[:id], 2) ||
        ArticleItem.find_by_article_id_and_language_id_and_article_type_id(game.article[:id], @lang[:id], 1)
          
      output<<"#{article_item.article_type.name.downcase}/#{game.id}" if article_item
      output_title = @lang.abbreviation != 'ru' ? "More info..." : "Подробнее..."
      if article_item && article_item.meta_title
        %Q{<a class="#{ css_class || "in_scores"}" href="http://#{request.host}/#{@lang.abbreviation}/#{output}" title="#{article_item.meta_title}">#{content || output_title}</a>}
      else 
        if article_item
          %Q{<a class="#{ css_class || "in_scores"}" href="http://#{request.host}/#{@lang.abbreviation}/#{output}" title="#{output_title}">#{content || output_title}</a>}
        else
          %Q{#{content || "&nbsp;"}}
        end
      end
    else
      %Q{#{content || "&nbsp;"}}
    end      
  end
  
  def link_for_related(game, current_id = nil)    
    item_team_home = TeamItem.find_by_language_id_and_team_id(@lang[:id], game.team_home[:id])
    item_team_guest = TeamItem.find_by_language_id_and_team_id(@lang[:id], game.team_guest[:id])
    output=""
    if game.article
      article_item = ArticleItem.find_by_article_id_and_language_id_and_article_type_id(game.article[:id], @lang[:id], 2) ||
        ArticleItem.find_by_article_id_and_language_id_and_article_type_id(game.article[:id], @lang[:id], 1)
      
      output<<article_item.article_type.name.downcase if article_item
    end
    if output.empty? || ( current_id && game[:id] == current_id)
      %Q{#{item_team_guest.abbreviation} &ndash; #{item_team_home.abbreviation}}
    else
      %Q{<a class="matches" href="http://#{request.host}/#{@lang.abbreviation}/#{output}/#{game[:id]}">#{item_team_guest.abbreviation} &ndash; #{item_team_home.abbreviation}</a>}      
    end
  end
  
  def link_for_button(article_type)
    output=""  
    item = ArticleItem.find_by_article_id_and_language_id_and_article_type_id(@article_item.article[:id],
      @lang[:id], article_type[:id])
    
    output<<"_disabled" if !item
    output<<"_over" if @article_item.article_type == article_type
    output<<"_#{@lang.abbreviation}" if @lang.abbreviation == 'ru'
    href = ( item )?("http://#{request.host}/#{@lang.abbreviation}/#{article_type.name}/#{item.article.game[:id]}"):("#{}")
    %Q{<a class="btn_#{article_type.name.downcase}#{output}" href="#{href}" title="#{article_type.name}" >&nbsp;</a>}    
    
  end
  
  def tag_for_language
    output_en, output_ru = "English", "Russian"
    output_en, output_ru = "Англ.", "Русский" if @lang.abbreviation == 'ru'
    %Q{<div class="language">
              <div class="lang_en"><a href="http://#{request.host}/en/" title="#{output_en}">#{output_en}<img alt="#{output_en}" width="16" height="11" src="http://#{request.host}/images/Front/us.gif"/></a></div>
              <div class="lang_ru"><a href="http://#{request.host}/ru/" title="#{output_ru}"><img width="16" alt="#{output_ru}" height="11" src="http://#{request.host}/images/Front/ru.gif"/>#{output_ru}</a></div>
       </div>}
  end
  
  #get list of player_game by team and game
  def get_players_rate(team, article_item)
    game = article_item.article.game
    @items = PlayerGame.find(:all,
      :conditions => "game_id = #{game[:id]} AND winner_type_id = #{ team[:id] == game.team_home_id ? 1 : 2} AND #{ article_item.article_type.name == 'matchup' ? "matchup_rate":"real_rate"} is not null",
      :order => ( article_item.article_type.name == 'matchup' ? "matchup_time Desc" : "real_time Desc") )
  end
  
  #return winner, lose or empty string
  def score_type(team, game)
    result=""
    if game.total_home && game.total_guest
      result = "winner" if ( game.team_home_id == team[:id] && game.total_home > game.total_guest ) ||
        ( game.team_guest_id == team[:id] && game.total_home < game.total_guest )
      result = "lose" if ( game.team_home_id == team[:id] && game.total_home < game.total_guest ) ||
        ( game.team_guest_id == team[:id] && game.total_home > game.total_guest )
    end
    result
  end
  
end
