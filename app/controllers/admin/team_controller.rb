class Admin::TeamController < AdminController

  def edit
    if params[MyAdmin.symbol_class(get_class)]
      entity = get_class.find(params[MyAdmin.symbol_class(get_class)])
      render :update do |page|
        page["container_for_#{MyAdmin.get_form_id(entity)}"].replace :partial => "form",
          :locals => { :object => entity, :action => 'update' }
      end
    elsif params[:item_id]
      entity = get_class.find(params[:item_id])
      render :partial => "form",
        :locals => { :object => entity, :action => 'update' }       
    end
  end
  
  def create
    if request.post?
      entity = get_class.new(params[MyAdmin.symbol_class(get_class)])      
      if entity.save
        flash[:notice] = MyAdmin.success_save_message(entity.class)
        type, items, paginator = get_params_for_list
        responds_to_parent do
          render :update do |page|
            page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "template/show",
              :locals => { :object => entity }
            page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
              :locals => { :type => type, :items => items, :paginator => paginator }
          end        
        end
      else
        responds_to_parent do
          render :update do |page|
            page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "form",
              :locals => { :object => entity, :action => 'create' }
          end
        end
      end
    end   
  end
  
  def update
    entity = get_class.find(params[:item_id])
    if entity.update_attributes(params[MyAdmin.symbol_class(get_class)])    
      flash[:notice] = MyAdmin.success_update_message(entity.class)
      type, items, paginator = get_params_for_list
      responds_to_parent do
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "template/show",
            :locals => { :object => entity }
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
    render :partial => 'form', :locals => { :object => item, :action => 'create' }
  end
  
end
