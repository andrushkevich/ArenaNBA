class CreatePlayerAndGame < ActiveRecord::Migration
  def self.up
    
    create_table :winner_types do |t|
      t.column :name, :string
    end
    
    create_table :games do |t|
      t.column :date, :date
      t.column :show, :boolean
      t.column :team_home_id, :integer
      t.column :team_guest_id, :integer
      t.column :period_first_home, :integer
      t.column :period_first_guest, :integer
      t.column :period_second_home, :integer
      t.column :period_second_guest, :integer
      t.column :period_third_home, :integer
      t.column :period_third_guest, :integer
      t.column :period_fourth_home, :integer
      t.column :period_fourth_guest, :integer
      t.column :total_over_time_guest, :integer
      t.column :total_over_time_home, :integer
      t.column :total_home, :integer
      t.column :total_guest, :integer
      t.column :difference, :integer
      t.column :winner_type_id, :integer
      t.column :season_id, :integer
    end
    
    execute "alter table games add constraint fk_game_home_team foreign key (team_home_id) references teams(id)"
    execute "alter table games add constraint fk_game_guest_team foreign key (team_guest_id) references teams(id)"
    execute "alter table games add constraint fk_game_winner_type foreign key (winner_type_id) references winner_types(id)"
    execute "alter table games add constraint fk_game_season foreign key (season_id) references seasons(id)"
    
    create_table :player_positions do |t|
      t.column :name, :string      
    end
    
    create_table :players do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :birthday, :date
      t.column :height, :integer
      t.column :weigh, :integer
      t.column :image_file_column, :string
      t.column :player_position_id, :integer
      t.column :team_id, :integer
    end
    
    execute "alter table players add constraint fk_player_position foreign key (player_position_id) references player_positions(id)"
    execute "alter table players add constraint fk_player_team foreign key (team_id) references teams(id)"
    
    create_table :player_games do |t|
      t.column :player_id, :integer
      t.column :game_id, :integer      
      t.column :winner_type_id, :integer
      t.column :matchup_rate, :integer
      t.column :matchup_time, :integer
      t.column :real_rate, :integer
      t.column :real_time, :integer
      t.column :date, :date
    end
    
    execute "alter table player_games add constraint fk_player_games_player foreign key (player_id) references players(id)"
    execute "alter table player_games add constraint fk_player_games_game foreign key (game_id) references games(id)"
    execute "alter table player_games add constraint fk_player_games_winner_type foreign key (winner_type_id) references winner_types(id)"
    
    create_table :player_teams do |t|
      t.column :player_id, :integer
      t.column :team_id, :integer
      t.column :start_period, :date
      t.column :end_period, :date
    end
    
    execute "alter table player_teams add constraint fk_player_team_player foreign key (player_id) references players(id)"
    execute "alter table player_teams add constraint fk_player_team_team foreign key (team_id) references teams(id)"
    
    create_table :player_rates do |t|
      t.column :player_id, :integer
      t.column :score, :integer
      t.integer :team_id
      t.integer :season_id
    end
    
    execute "alter table player_rates add constraint fk_player_rate_player foreign key (player_id) references players(id)"
    execute "alter table player_rates add constraint fk_player_rates_season foreign key (season_id) references seasons(id)"
    execute "alter table player_rates add constraint fk_player_rates_team foreign key (team_id) references teams(id)"
    
  end

  def self.down
    drop_table :winner_types
    drop_table :games
    drop_table :player_positions
    drop_table :players
    drop_table :player_games
    drop_table :player_teams
    drop_table :player_rates
  end
end
