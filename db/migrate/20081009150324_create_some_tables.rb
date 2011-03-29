class CreateSomeTables < ActiveRecord::Migration
  def self.up
    
    create_table :contents do |t|
      t.column :url , :string
      t.column :content_of_page ,:text
      t.column :language_id, :integer
      t.column :meta_title, :string
      t.column :meta_keywords, :string
      t.column :meta_description, :string
      t.timestamps
    end
    
    create_table :languages do |t|
      t.column :name , :string
      t.column :abbreviation, :string
    end
    
    create_table :settings do |t|
      t.column :key, :string
      t.column :value, :text
    end

    execute "alter table contents add constraint fk_content_language foreign key (language_id) references languages(id)"
    
  end

  def self.down
    drop_table :languages
    drop_table :settings
    drop_table :contents
  end
end
