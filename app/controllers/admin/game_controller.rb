class Admin::GameController < AdminController
  
  def page_size
    25
  end

  def clear_advanced_conditions
    session["show_advanced"] = session["cond_date"] = nil
    super
  end
  
  def set_advanced_conditions
    date = Date.new( params["condition"]["date(1i)"].to_i, params["condition"]["date(2i)"].to_i, params["condition"]["date(3i)"].to_i)
    session[list_advanced_condition_key] = "date = '#{date.to_s}'"
    session["show_advanced"] = true
    session["cond_date"] = date
    update_list
  end 
  
end
