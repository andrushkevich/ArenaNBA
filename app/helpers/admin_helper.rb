module AdminHelper
  
  include MyAdmin
  
  # Get human's name for list
  def title_for_list(object)
    return "List of " + MyAdmin.prepare_title(object)
  end
  
  def symbol_object(object)
    MyAdmin.symbol_object(object)
  end
  
  #Get human's name of column
  def column_name(column)
    tmp = ''
    column.name.gsub(/_/, ' ').gsub(/id/,"").split.each{|word| tmp += word.capitalize + ' '}
    return tmp
  end
  
  #Format value of attribute.
  def format_value(item, name)
    value = item.send(name)
    if item.class.reflections[name.gsub(/_id/,"").to_sym] && value
      obj = Object.const_get(item.class.reflections[name.gsub(/_id/,"").to_sym].class_name).find(value)
      value = (obj.respond_to? :to_label) ? (obj.to_label) : (obj.name)
    end
    value = image_tag( url_for_file_column(item, name, :absolute => true) ) if name.to_s.ends_with?("file_column") && value
    return  value ? value : "---"
  end
  
  #Get array of object's column for list
  def get_list_columns(object)
    MyAdmin.get_list_columns(object)
  end
  
  # Get human's name for form
  def title_for_form(object)
    prefix = object.id != nil ? 'Edit' : 'Create'
    return prefix + ' ' + MyAdmin.prepare_title(object.class.name)
  end
  
  #get all fields of model
  def object_attributes(object, action = nil)
    MyAdmin.get_object_attributes(object, action)
  end
  
  #render html tag for attribute
  def attributes_tag(f, object, attribute, fckeditor = false)
    type = object.class.columns_hash[attribute.to_s]
    return f.password_field attribute.to_s if attribute.to_s.ends_with? "password"
    return f.select(attribute.to_s, MyAdmin.get_related_select_options(attribute.to_s, object), {}, :class => "relation" ) if attribute.to_s.ends_with? "id"
    return file_column_field(f.object_name.to_s, attribute.to_s) if attribute.to_s.ends_with?("file_column")
    return f.file_field attribute.to_s if attribute.to_s.ends_with?("file")    
    case type.type
    when :string
      f.text_field type.name
    when :text
      f.text_area  type.name
    when :integer
      f.text_field type.name
    when :datetime
      f.datetime_select type.name
    when :date
      f.date_select type.name      
    when :boolean
      f.check_box type.name
    else
      f.text_field attribute
    end    
  end
  
  #get unique id for form by object
  def get_form_id(object)
    MyAdmin.get_form_id(object)
  end
  
  #get id by type
  def get_id_by_type(type)
    MyAdmin.get_name_by_type(type)
  end
  
  #it allows us to have the same familiar API as link_to_remote
  def button_to_remote name, css_class, options = {}
    button_to_function name, remote_function(options), :class=>css_class
  end
  
end
