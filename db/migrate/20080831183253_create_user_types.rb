class CreateUserTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types do |t|
      t.string :name
      t.integer :permission_level
      t.timestamps
    end
  end

  def self.down
    drop_table :user_types
  end
end
