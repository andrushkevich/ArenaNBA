class UserType < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_numericality_of :permission_level
  
  def get_create_attributes
    [:name, :permission_level]
  end
  
  def get_update_attributes
    [:name, :permission_level]
  end
  
  def get_show_attributes
    [:name, :permission_level, :created_at,:updated_at ]
  end
  
  def self.get_list_columns
    [:name, :permission_level, :updated_at]
  end
  
end
