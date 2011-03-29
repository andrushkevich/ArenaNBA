class Season < ActiveRecord::Base

  belongs_to :type,
    :class_name => "TeamType",
    :foreign_key => "type_id"


  validates_presence_of :name, :value, :order
  validates_uniqueness_of :name, :order
  validates_length_of :name, :maximum=>255

  def to_label
    "#{name} "
  end
end