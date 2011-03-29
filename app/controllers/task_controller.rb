class TaskController < ApplicationController
  
  layout 'admin'

  def calculate_nba_rate
    @message = calculate_player_rate(1)
  end

  def calculate_wnba_rate
    @message = calculate_player_rate(2)
  end

  def set_season_of_clear_game
    message = "Complete Successfully"
    current_nba_season = Season.find :first, :conditions => "type_id = 1", :order => "'order'"
    current_wnba_season = Season.find :first, :conditions => "type_id = 2", :order => "'order'"
    nba_games = Game.find :all, :include => :team_guest, :conditions => "teams.team_type_id = 1 AND ( season_id is null || season_id = 0)"
    nba_games.each { |item|
        item[:season_id] = current_nba_season[:id]
        if !item.save!
          message = item.error
        end
    }
    wnba_games = Game.find :all, :include => :team_guest, :conditions => "teams.team_type_id = 2 AND ( season_id is null || season_id = 0)"
    wnba_games.each { |item|
        item[:season_id] = current_wnba_season[:id]
        if !item.save!
          message = item.error
        end
    }
  end

  def set_player_rate
    rates = PlayerRate.find(:all, :include => :player)
    rates.each{ |item|
      item[:team_id] = item.player[:team_id]
      item[:season_id]=Game.current_season_id(item.player.team[:team_type_id])
      item.save
    }
  end

  def clear_nba_team
    ids = PlayerRate.find_by_sql ["SELECT id FROM players WHERE team_id
            IN ( SELECT id FROM teams WHERE team_type_id =? )", 1]
    ids_string = ''
    ids.each{ |item|
      ids_string += (item.id.to_s + ', ')
    }
    ids_string += '0'
    players = Player.find(:all, :include=>:team, :conditions=>"id in (" + ids_string + ")")
    players.each { |item|
      item[:team_id] = nil
      item.save
    }
  end

  private

  def calculate_player_rate(item_type_id)
    message = "Complete Successfully"

    ids = PlayerRate.find_by_sql ["SELECT id FROM players WHERE team_id
            IN ( SELECT id FROM teams WHERE team_type_id =? )", item_type_id]
    ids_string = ''
    ids.each{ |item|
      ids_string += (item.id.to_s + ', ')
    }
    ids_string += '0'

    rates = PlayerGame.find(:all, :select => "SUM(real_time * real_rate)/100 as rate, player_id",
      :from => "player_games left join games on games.id = player_games.game_id",
      :group => "player_id", :conditions => "player_id in(" +
      ids_string + ") and season_id=" + Game.current_season_id(item_type_id).to_s)
    rates.each{|rate|
      item = PlayerRate.find_by_player_id_and_season_id(rate.player_id,Game.current_season_id(item_type_id)) || PlayerRate.new(:player_id => rate.player_id, :team_id => Player.find(rate.player_id), :season_id=>Game.current_season_id(item_type_id))
      item.score = rate.rate
      if !item.save!
        message = "Error!!!"
      end
    }
    message
  end
  
  #  def hide_methods
  #    items = PlayerGame.find(:all)
  #    @message = "ok"
  #    begin
  #    items.each{ |item|
  #      item.winner_type_id = nil
  #      item.winner_type_id = 1 if item.player[:team_id] == item.game[:team_home_id]
  #      item.winner_type_id = 2 if item.player[:team_id] == item.game[:team_guest_id]
  #      item.save!
  #    }
  #    rescue Exception => e
  #      @message = e.message
  #    end
  #  end

end
