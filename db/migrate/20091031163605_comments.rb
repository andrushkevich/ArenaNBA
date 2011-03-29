class Comments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :text, :text
      t.column :article_item_id , :integer
      t.column :nickname, :string
    end

    execute "alter table comments add constraint fk_article_items_comment foreign key (article_item_id) references article_items(id)"
  end

  def self.down
    drop_table :comments
  end
end
