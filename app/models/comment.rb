class Comment < ActiveRecord::Base

  belongs_to:article_item
  validates_length_of :nickname, :maximum=>255
  before_create :set_datetime

  def to_label
    "#{:nickname} -- #{:creat_at}"
  end

  def set_datetime
    self[:creat_at] = Date.today()
  end

  def self.get_list_columns
    [:article_item_id, :nickname, :created_at]
  end

  def get_create_attributes
    [:article_item_id, :nickname, :text]
  end

  def get_update_attributes
    [:article_item_id, :nickname, :text]
  end

end