class ArticleType < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def to_label
    "#{name}"
  end
  
  
end
