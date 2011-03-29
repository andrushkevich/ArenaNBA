class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.integer :user_type_id
      t.timestamps
    end
    
    execute "alter table users add constraint fk_user_type_of_user foreign key (user_type_id) references user_types(id)"
    
  end

  def self.down
    drop_table :users
  end
end
