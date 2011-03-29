class CreateRuPlayers < ActiveRecord::Migration
  def self.up
    create_table :ru_players do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :player_id, :integer
    end
    
    execute "alter table ru_players add constraint fk_ru_players_to_players foreign key (player_id) references players(id)"
  end

  def self.down
    drop_table :ru_players
  end
end
