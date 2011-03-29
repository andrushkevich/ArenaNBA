class Admin::MatchupArticleController < AdminController
  
  attr_accessor :has_errors
  
  def show
    entity = get_class.find(params[:item_id])
    en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(entity.article_id)
    render :partial => "show", :locals => { :object => entity, :en_article => en_article, 
      :ru_article => ru_article, :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate }
  end
  
  def edit
    if params[:article_id]
      entity = get_class.find(params[:article_id])
      en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(entity.article_id)
      render :update do |page|
        page["container_for_#{MyAdmin.get_form_id(entity)}"].replace :partial => "form",
          :locals => { :object => entity, :action => 'update', :en_article => en_article, 
          :ru_article => ru_article, :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate }
      end
    elsif params[:item_id]
      entity = get_class.find(params[:item_id])
      en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(entity.article_id)
      render :partial => "form",
        :locals => { :object => entity, :action => 'update', :en_article => en_article, 
        :ru_article => ru_article, :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate }       
    end
  end
  
  def create
    if request.post?
      entity = get_class.new(params[MyAdmin.symbol_class(get_class)])
      if save_new_items
        flash[:notice] = @has_errors ? MyAdmin.save_with_errors_message("Article&PlayersRate") : MyAdmin.success_save_message("Article&PlayersRate")        
        type, items, paginator = get_params_for_list
        en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(entity.article_id)
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "show",
            :locals => { :object => entity, :en_article => en_article, 
            :ru_article => ru_article, :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate }
          page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
            :locals => { :type => type, :items => items, :paginator => paginator }
        end        
      else
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "form",
            :locals => { :object => entity, :action => 'create' }
        end
      end
    end   
  end
  
  def update
    entity_id = params[:item_id] || params[:article_id]
    entity = get_class.find(entity_id)
    if save_new_items(entity.article_id)
      flash[:notice] = @has_errors ? MyAdmin.update_with_errors_message("Article&PlayersRate") : MyAdmin.success_update_message("Article&PlayersRate")
      type, items, paginator = get_params_for_list
      en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(entity.article_id)
      render :update do |page|
        page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "show",
          :locals => { :object => entity, :en_article => en_article, 
          :ru_article => ru_article, :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate }
        page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
          :locals => { :type => type, :items => items, :paginator => paginator }
      end
    else
      render :update do |page|
        page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "form",
          :locals => { :object => entity, :action => 'update' }
      end
    end
  end
  
  def create_new_item
    item = get_class.new
    render :partial => 'form', :locals => { :object => item, :action => 'create', :en_article => nil, 
      :ru_article => nil, :guest_players => nil, :home_players => nil, :players_rate => nil }
  end
  
  def delete
    if request.delete?
      entity = get_class.find(params[:item_id])
      game = Article.find(entity.article_id).game
      if ArticleItem.find_all_by_article_id(entity.article_id).size < 3
        PlayerGame.delete_all "game_id = #{game.id}" 
      end
      ArticleItem.destroy_all "article_id = #{entity.article_id} and article_type_id = #{article_type_id}" 
      update_list
    end
  end
  
  def get_players
    if params["article_players_matchup_rate_article_id"]
      en_article, ru_article, guest_players, home_players, players_rate = get_params_for_form(params["article_players_matchup_rate_article_id"].to_i)
      render :update do |page|
        page["players_container"].reload :locals => {
          :guest_players => guest_players, :home_players => home_players, :players_rate => players_rate
        }
      end
    end
  end
  
  def clear_advanced_conditions
    session["show_advanced"] = session["cond_date"] = nil
    super
  end
  
  def set_advanced_conditions
    date = Date.new( params["condition"]["date(1i)"].to_i, params["condition"]["date(2i)"].to_i, params["condition"]["date(3i)"].to_i)
    session[list_advanced_condition_key] = "article_id in (select id from articles where game_id in ( select id from games where date = '#{date.to_s}'))"
    session["show_advanced"] = true
    session["cond_date"] = date
    update_list
  end

  protected
  
  def article_type_id
    1
  end
  
  def addition_condition
    "language_id = 1 and article_type_id = #{article_type_id}"
  end

  def set_object_type
    @object_name = "ArticlePlayersMatchupRate"
  end
  
  def get_class
    ArticlePlayersMatchupRate
  end
  
  def page_size
    35
  end
  
  private
  
  def get_params_for_form(article_id)
    en_article = ArticleItem.find_by_language_id_and_article_id_and_article_type_id(1, article_id, article_type_id)
    ru_article = ArticleItem.find_by_language_id_and_article_id_and_article_type_id(2, article_id, article_type_id)
    game = Article.find(article_id).game
    guest_players = Player.find_all_by_team_id(game.team_guest.id, :order => "first_name")
    home_players = Player.find_all_by_team_id(game.team_home.id, :order => "first_name")
    players_rate = {}
    guest_players.each{ |item| players_rate[item.id] = PlayerGame.find_by_player_id_and_game_id(item.id, game.id) }
    home_players.each{ |item| players_rate[item.id] = PlayerGame.find_by_player_id_and_game_id(item.id, game.id) }
    return en_article, ru_article, guest_players, home_players, players_rate
  end
  
  def save_new_items(article_id = nil)
    @has_errors = false
    if article_id
      eng_article = fill_article(ArticleItem.find_by_article_id_and_language_id(article_id, 1), "english")
      ru_article = fill_article(ArticleItem.find_by_article_id_and_language_id(article_id, 2), "russian")
    else
      eng_article = fill_article(ArticleItem.new( :language_id => 1, :article_type_id => article_type_id), "english")
      ru_article = fill_article(ArticleItem.new( :language_id => 2, :article_type_id => article_type_id), "russian")
    end    
    players = bind_players
    if eng_article.save && ru_article.save
      players.each{ |item| 
        if !item.save
          @has_errors = true
        end
      }        
      return true
    end
    false
  end
  
  def bind_players
    players = []
    game = Article.find(params["article_players_matchup_rate"]["article_id"].to_i).game
    if game      
      params["team_guest"].each_pair { |key, value| 
        if !value["score"].blank? || !value["minute"].blank?
          item = PlayerGame.find_by_player_id_and_game_id(key.to_i, game.id) || PlayerGame.new(:player_id => key.to_i, :game_id => game.id, :date => game.date, :winner_type_id => 2)
          winner_type = WinnerType.find(2)
          item.matchup_rate = value["score"].to_i
          item.winner_type = winner_type
          item.matchup_time = value["minute"].to_i
          players << item
        else
          item = PlayerGame.find_by_player_id_and_game_id(key.to_i, game.id)
          if item
            if item.real_rate || item.real_time
              item.matchup_rate = item.matchup_time = nil
            else
              item.destroy
            end          
          end
        end
      }
      params["team_home"].each_pair { |key, value| 
        if !value["score"].blank? || !value["minute"].blank?
          item = PlayerGame.find_by_player_id_and_game_id(key.to_i, game.id) || PlayerGame.new(:player_id => key.to_i, :game_id => game.id, :date => game.date, :winner_type_id => 1)
          winner_type = WinnerType.find(1)
          item.matchup_rate = value["score"].to_i
          item.matchup_time = value["minute"].to_i
          item.winner_type = winner_type
          players << item
        else
          item = PlayerGame.find_by_player_id_and_game_id(key.to_i, game.id)
          if item
            if item.real_rate || item.real_time
              item.matchup_rate = item.matchup_time = nil
            else
              item.destroy
            end          
          end
        end
      }
    end
    players
  end
  
  def fill_article(item,language)
    item.article_id = params["article_players_matchup_rate"]["article_id"]
    item.meta_title = params[language]["meta_title"]
    item.meta_keywords = params[language]["meta_keywords"]
    item.meta_description = params[language]["meta_description"]
    item.text = params[language]["text"]
    item
  end
  
end
