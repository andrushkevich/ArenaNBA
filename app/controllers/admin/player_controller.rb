class Admin::PlayerController < AdminController
  
  def show
    entity = get_class.find(params[:item_id])
    render :partial => "show", :locals => { :object => entity, :ru_player => (entity.ru_player || RuPlayer.new) }
  end
  
  def edit
    if params[MyAdmin.symbol_class(get_class)]
      entity = get_class.find(params[MyAdmin.symbol_class(get_class)])
      render :update do |page|
        page["container_for_#{MyAdmin.get_form_id(entity)}"].replace :partial => "form",
          :locals => { :object => entity, :action => 'update', :ru_player => (entity.ru_player || RuPlayer.new) }
      end
    elsif params[:item_id]
      entity = get_class.find(params[:item_id])
      render :partial => "form",
        :locals => { :object => entity, :action => 'update', :ru_player => (entity.ru_player || RuPlayer.new) }       
    end
  end
  
  def create
    if request.post?
      entity = get_class.new(params[MyAdmin.symbol_class(get_class)])
      ru_player = RuPlayer.new(params[:ru_player])
      begin
        Player.transaction do
          entity.ru_player = ru_player
          entity.save!        
          ru_player.save!          
        end
        flash[:notice] = MyAdmin.success_save_message(entity.class)
        type, items, paginator = get_params_for_list
        responds_to_parent do
          render :update do |page|
            page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "show",
              :locals => { :object => entity, :ru_player => (entity.ru_player || RuPlayer.new) }
            page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
              :locals => { :type => type, :items => items, :paginator => paginator }
          end        
        end
      rescue ActiveRecord::RecordInvalid => e
        responds_to_parent do
          render :update do |page|
            page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "form",
              :locals => { :object => entity, :ru_player => ru_player, :action => 'create' }
          end      
        end
      end
    end   
  end
  
  def update
    entity = get_class.find(params[:item_id])
    entity.ru_player = RuPlayer.new if !entity.ru_player
    if entity.update_attributes(params[MyAdmin.symbol_class(get_class)]) && entity.ru_player.update_attributes(params[:ru_player])    
      flash[:notice] = MyAdmin.success_update_message(entity.class)
      type, items, paginator = get_params_for_list
      responds_to_parent do
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "show",
            :locals => { :object => entity, :ru_player => (entity.ru_player || RuPlayer.new) }
          page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
            :locals => { :type => type, :items => items, :paginator => paginator }
        end      
      end
    else
      responds_to_parent do
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "form",
            :locals => { :object => entity, :action => 'update' }
        end
      end
    end
  end
  
  def create_new_item
    item = get_class.new
    ru_player = RuPlayer.new
    render :partial => 'form', :locals => { :object => item, :action => 'create', :ru_player => ru_player }
  end
  
  def page_size
    25
  end
  
  def clear_advanced_conditions
    session["show_advanced"] = session["cond_team"] = nil
    super
  end
  
  def set_advanced_conditions
    session[list_advanced_condition_key]="team_id = #{params["condition"]["team"]}"
    session["show_advanced"] = true
    session["cond_team"] = params["condition"]["team"]
    session[list_page_num_key] = nil
    update_list
  end
  
end
