class FrontController < ApplicationController

  layout 'index'
  before_filter :set_language
  before_filter :set_date  
  
  
  def index      
    @content = Setting.find_by_key('home_default_text_' + @lang.abbreviation).value
    @nba_games = Game.find(:all, :include => :team_guest,
      :conditions => ['games.date >= ? AND games.date < ? AND teams.team_type_id = 1', @date,
        @date + 1.day ], :order=>'date')
    @wnba_games = Game.find(:all, :include => :team_guest,
      :conditions => ['games.date >= ? AND games.date < ? AND teams.team_type_id = 2', @date,
        @date + 1.day ], :order=>'date')
  end
  
  def show_article
    article_type = ArticleType.find_by_name(params[:article_type])
    game = Game.find_by_id(params[:id])
    @article_item = ArticleItem.find_by_language_id_and_article_type_id_and_article_id(@lang[:id], article_type[:id], game.article[:id])
    @meta_info = MetaInfo.bind_from_object(@article_item)
    @related_game = Game.find(:all,
      :conditions=>['date >= ? AND date < ?', game.date,
        game.date + 1.day],
      :order=>'date')
    if @article_item
      @date = @article_item.article.game.date
      session[:month], session[:day], session[:year] = 
        @date.month, @date.day, @date.year
    end
  end
  
  def teams_list
    team_type = TeamType.find_by_name(params[:type]) if params[:type]
    if team_type
      @east_teams = Team.find_all_by_team_division_id_and_team_type_id(1, team_type[:id], :order => "name")
      @west_teams = Team.find_all_by_team_division_id_and_team_type_id(2, team_type[:id], :order => "name")
    end
  end
  
  def team
    @team = Team.find(params[:id])
    @meta_info = TeamMetaInfo.bind_from_template("team", @team, @lang)
    if @team
      @games = Game.find(:all, :conditions => "season_id = #{Game.current_season_id(@team[:team_type_id])} and (team_home_id = #{@team[:id]} or team_guest_id = #{@team[:id]})",
        :order => "date DESC")
    end
  end
  
  def player
    @player = Player.find(params[:id]) if params[:id]
    season_id = Game.current_season_id(@player.team[:team_type_id])
    @meta_info = PlayerMetaInfo.bind_from_template("player", @player, @lang)
    if @player
      @scores = PlayerGame.find_by_sql("SELECT player_games.* FROM player_games INNER JOIN games ON player_games.game_id = games.id
        where season_id = #{season_id} and player_id = #{@player[:id]} AND real_time IS NOT NULL AND real_rate IS NOT NULL
        order by player_games.date DESC")
      @last5 = PlayerGame.find_by_sql ["SELECT AVG( p.real_rate ) AS rate, AVG( p.real_time ) AS time
          FROM ( SELECT player_games.player_id, player_games.real_rate, player_games.real_time, player_games.date
      FROM player_games INNER JOIN games ON games.id = player_games.game_id
      WHERE player_id =? AND games.season_id =? AND real_rate IS NOT NULL ORDER BY player_games.date DESC
      LIMIT 5 ) AS p GROUP BY p.player_id", @player[:id], season_id]
      @last10 = PlayerGame.find_by_sql ["SELECT AVG( p.real_rate ) AS rate, AVG( p.real_time ) AS time
          FROM ( SELECT player_games.player_id, player_games.real_rate, player_games.real_time, player_games.date
      FROM player_games INNER JOIN games ON games.id = player_games.game_id
      WHERE player_id =? AND games.season_id =? AND real_rate IS NOT NULL ORDER BY player_games.date DESC
      LIMIT 10 ) AS p GROUP BY p.player_id", @player[:id], season_id]
      @all = PlayerGame.find_by_sql ["SELECT AVG( p.real_rate ) AS rate, AVG( p.real_time ) AS time
          FROM ( SELECT player_games.player_id, player_games.real_rate, player_games.real_time, player_games.date
      FROM player_games INNER JOIN games ON games.id = player_games.game_id
      WHERE player_id =? AND games.season_id =? AND real_rate IS NOT NULL ORDER BY player_games.date DESC
      ) AS p GROUP BY p.player_id", @player[:id], season_id]
    end    
  end
  
  def static_content
    @content = Content.find_by_url_and_language_id(params[:url],@lang[:id].to_s)
    if !@content
      redirect_to '404.html'
    end
  end
  
  def rate
    @page_num = params[:page_num] ? params[:page_num].to_i : 1
    team_type = TeamType.find_by_name(params[:type])
    ids = PlayerRate.find_by_sql ["SELECT id FROM players WHERE team_id
            IN ( SELECT id FROM teams WHERE team_type_id =? )", team_type[:id]]
    ids_string = ''
    ids.each{ |item|
      ids_string += (item.id.to_s + ', ')
    }
    ids_string += '0'
    aver = (PlayerRate.find_by_sql ["SELECT COUNT(*) FROM player_rates where player_id in (" +
          ids_string + ") and season_id=" + Game.current_season_id(team_type[:id]).to_s])
    aver = (aver[0]['COUNT(*)']).to_f / 30
    @page_total =  ( aver != 0 && aver % 1 > 0 ) ? (aver.to_i + 1) : aver.to_i 
    @rates = PlayerRate.find( :all, :order => "score DESC", :limit => 30,
      :conditions => ["player_id in (?) and season_id=(?)", ids, Game.current_season_id(team_type[:id])], :offset => ( 30 * ( @page_num - 1)) )
  end
  
  private
  
  def set_language
    if params[:lang]
      @lang = Language.find_by_abbreviation(params[:lang])
    else
      @lang = Language.find :first
    end    
  end
  
  def set_date
    if params[:month] && params[:day] && params[:year]
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)      
    else
      if session[:month] && session[:day] && session[:year]
        @date = Date.new(session[:year].to_i, session[:month].to_i, session[:day].to_i)
      else
        game = Game.find(:first, :order => "games.date desc", :select => "games.*", :from => "games, articles, article_items",
          :conditions => "articles.game_id = games.id AND article_items.article_id = articles.id", :limit => 1 )
        @date = game ? game.date : DateTime.now
      end      
    end
    session[:month], session[:day], session[:year] = 
      @date.month, @date.day, @date.year     
  end
end
