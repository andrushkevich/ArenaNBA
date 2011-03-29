class Article < ActiveRecord::Migration
  def self.up
    create_table :article_types do |t|
      t.column :name, :string 
    end
    
    create_table :articles do |t|
      t.column :name, :string
      t.column :game_id, :integer      
    end
    
    execute "alter table articles add constraint fk_article_game foreign key (game_id) references games(id)"
    
    create_table :article_items do |t|
      t.column :text, :text
      t.column :language_id, :integer
      t.column :article_id, :integer
      t.column :article_type_id, :integer
      t.column :meta_title, :string
      t.column :meta_keywords, :string
      t.column :meta_description, :string
    end
    
    execute "alter table article_items add constraint fk_article_items_language foreign key (language_id) references languages(id)"
    execute "alter table article_items add constraint fk_article_arcticle foreign key (article_id) references articles(id)"
    execute "alter table article_items add constraint fk_article_arcticle_type foreign key (article_type_id) references article_types(id)"
    
  end

  def self.down
    drop_table :article_types
    drop_table :articles
    drop_table :article_items
  end
end
