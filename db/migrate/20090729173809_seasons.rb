class Seasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.column :name, :string
      t.column :value, :datetime
      t.column :order, :integer
      t.column :type_id, :integer
    end

    execute "alter table seasons add constraint fk_seasons_team_type foreign key (type_id) references team_types(id)"
  end

  def self.down
    drop_table :seasons
  end
end
