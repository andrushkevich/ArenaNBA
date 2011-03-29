class MetaInfo
  attr_accessor :meta_title, :meta_keywords, :meta_description
  
  def initialize(title = nil, keywords = nil, description = nil)
    @meta_title, @meta_keywords, @meta_description =
      title, keywords, description
  end
  
  def self.bind_from_template(type, object, lang)
    meta = new()
    if object
      meta.bind_field_from_template(object, type,lang, :meta_keywords)
      meta.bind_field_from_template(object, type,lang, :meta_title)
      meta.bind_field_from_template(object, type,lang, :meta_description)
    end
    meta
  end
  
  def bind_field_from_template(object, type,lang, field)
    template = Setting.find_by_key("#{type.to_s}_#{field.to_s}_#{lang.abbreviation}")
    self.instance_variable_set("@" + field.to_s, self.prepare_template(object, template.value, lang)) if template && template.value
  end
  
  def self.bind_from_object(object)
    meta = new()
    if object      
      meta.bind_field_from_object(object, :meta_keywords)
      meta.bind_field_from_object(object, :meta_title)
      meta.bind_field_from_object(object, :meta_description)         
    end
    meta
  end
  
  def bind_field_from_object(object, field)
    if object.respond_to? field
      self.instance_variable_set("@" + field.to_s, object.send(field))
    end
  end

  def prepare_template(object, template, lang)
    template
  end
end