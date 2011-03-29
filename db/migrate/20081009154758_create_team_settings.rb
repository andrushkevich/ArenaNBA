class CreateTeamSettings < ActiveRecord::Migration
  def self.up
    
    create_table :team_types do |t|
      t.column :name , :string
    end
    
    create_table :team_divisions do |t|
      t.column :name, :string
    end
    
    create_table :teams do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :image_file_column, :string
      t.column :team_division_id, :integer
      t.column :team_type_id, :integer
    end
    
    create_table :team_items do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :abbreviation, :string
      t.column :language_id, :integer
      t.column :team_id, :integer
    end
    
    execute "alter table teams add constraint fk_team_type_of_team foreign key (team_type_id) references team_types(id)"    
    execute "alter table teams add constraint fk_team_divisions foreign key (team_division_id) references team_divisions(id)"
    execute "alter table team_items add constraint fk_team_item_language foreign key (language_id) references languages(id)"
    execute "alter table team_items add constraint fk_team_item_team foreign key (team_id) references teams(id)"
    
    
    
  end

  def self.down
    drop_table :team_items
    drop_table :teams
    drop_table :teams_divisions
    drop_table :team_types
  end
end
