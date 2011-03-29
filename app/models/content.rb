class Content < ActiveRecord::Base
  
  belongs_to :language
  
  validates_presence_of :url
  validates_length_of :url, :maximum=>255
  
  validates_length_of :content_of_page, :maximum=>4000
  
  validates_length_of :meta_title, :maximum => 255
  validates_length_of :meta_keywords, :maximum => 255
  validates_length_of :meta_description, :maximum => 255
  validates_presence_of :meta_description, :meta_title, :meta_keywords
  
  def to_label
    "#{url.to_s}"
  end
  
  def get_create_attributes
    [:url, :language_id, :content_of_page, :meta_title, :meta_keywords, :meta_description]
  end
  
  def get_update_attributes
    [:url, :language_id, :content_of_page, :meta_title, :meta_keywords, :meta_description]
  end
  
  def self.get_list_columns
    [:url, :language_id, :updated_at]
  end
  
end
