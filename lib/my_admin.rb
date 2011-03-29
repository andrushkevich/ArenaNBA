module MyAdmin
 
  # Symbol name of object
  def self.symbol_object(object)
    symbol_class(object.class)
  end
  
  #Symbol name of class
  def self.symbol_class(type)
    prepare_title(type.name).downcase.gsub(/ /,'_').to_sym
  end
    
  def self.prepare_title(string)
    tmp = ''
    string.to_s.each_byte { |i| 
      if i.chr =~ /[A-Z]/
        tmp += ' '
      end
      tmp += i.chr
    }
    return tmp.strip
  end
  
  #get id by type
  def self.get_name_by_type(type)
    prepare_title(type.name).downcase.gsub(/ /, '_')
  end
  
  #get unique id for form by object
  def self.get_form_id(object)
    id = get_name_by_type(object.class) + '_'
    id += object.id ? object.id.to_s : 'new' 
  end
  
  #Get array of object's column for list
  def self.get_list_columns(object)
    if object.respond_to?(:get_list_columns)
      object.columns.reject{ |item| !object.get_list_columns.include?(item.name.to_sym) }      
    else
      object.columns
    end
  end
  
  #Prepare condition for list
  def self.prepare_conditions(param, type)
    conditions = ''
    MyAdmin.get_list_columns(type).each { |column| 
      if column.type == :string
        conditions += "#{column.name} like '%#{param}%' OR "
      end      
    }
    conditions += "false"
  end
  
  #Message for successfully save item
  def self.success_save_message(type)
    "#{prepare_title(type)} was successfully created."
  end
  
  #Message for successfully save item
  def self.success_update_message(type)
    "#{prepare_title(type)} was successfully updated."
  end

  #get attributes of object for current action
  def self.get_object_attributes(object, action=nil)
    result = {}
    result = (object.respond_to? "get_#{action}_attributes".to_sym) ? 
      object.method("get_#{action}_attributes".to_sym).call : default_object_attributes(object, action)
  end
  
  #get default object's attributes
  def self.default_object_attributes(object, action=nil)
    attr = object.attributes
    if action == "create" || action == "update"
      attr.delete('created_at')
      attr.delete('updated_at')
    end
    attr.delete('id')
    attr.keys
  end
  
  #get options for select_tag on form.
  def self.get_related_select_options(attribute, object, condition = nil, order = nil)
    related_model = Object.const_get(object.class.reflections[attribute.gsub(/_id/,"").to_sym].class_name)
    return get_select_options(related_model, condition, order)
  end
  
  def self.get_select_options(model, condition = nil, order = nil)
    options = []
    if model
      items = model.find(:all, :conditions => condition, :order => order) 
      if items
        items.each{|item| options << [ (item.respond_to? :to_label)?(item.to_label):((item.respond_to? :name)?(item.name):(item.to_s)) , item.id]}
      end
    end
    return options
  end

  
    
end
