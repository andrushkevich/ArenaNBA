class AdminController < ApplicationController
  
  layout 'admin', :except=>[:login, :logout]
  before_filter :authorize, :except => :login
  
  include MyAdmin
  include Paginator
  
  before_filter :set_object_type
  
  attr_accessor :object_name
  
  def login
    session[:user_id] = nil    
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id]=user.id
        redirect_to(:action=>'default')
      else
        flash[:notice]="Incorrect login/password"
      end
    end
  end

  def logout
    reset_session
    redirect_to :action=>'login'
  end
  
  def default    
  end
    
  def show
    entity = get_class.find(params[:item_id])
    render :partial => "template/show", :locals => { :object => entity }
  end
  
  def edit
    if params[MyAdmin.symbol_class(get_class)]
      entity = get_class.find(params[MyAdmin.symbol_class(get_class)])
      render :update do |page|
        page["container_for_#{MyAdmin.get_form_id(entity)}"].replace :partial => "template/form",
          :locals => { :object => entity, :action => 'update' }
      end
    elsif params[:item_id]
      entity = get_class.find(params[:item_id])
      render :partial => "template/form",
        :locals => { :object => entity, :action => 'update' }       
    end
  end
  
  def create
    if request.post?
      entity = get_class.new(params[MyAdmin.symbol_class(get_class)])      
      if entity.save
        flash[:notice] = MyAdmin.success_save_message(entity.class)
        type, items, paginator = get_params_for_list
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "template/show",
            :locals => { :object => entity }
          page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
            :locals => { :type => type, :items => items, :paginator =>  paginator}
        end        
      else
        render :update do |page|
          page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_new"].replace :partial => "template/form",
            :locals => { :object => entity, :action => 'create' }
        end
      end
    end   
  end
  
  def update
    entity = get_class.find(params[:item_id])
    if entity.update_attributes(params[MyAdmin.symbol_class(get_class)])    
      flash[:notice] = MyAdmin.success_update_message(entity.class)
      type, items, paginator = get_params_for_list
      render :update do |page|
        page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "template/show",
          :locals => { :object => entity }
        page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
          :locals => { :type => type, :items => items, :paginator => paginator }
      end      
    else
      render :update do |page|
        page["container_for_#{MyAdmin.get_name_by_type(entity.class)}_#{entity.id}"].replace :partial => "template/form",
          :locals => { :object => entity, :action => 'update' }
      end
    end
  end
  
  def delete
    if request.delete?
      entity = get_class.find(params[:item_id])
      entity.destroy
      update_list
    end
  end
  
  def index
    @type, @items, @paginator = get_params_for_list
    render :template => 'template/index'
  end
  
  def create_new_item
    item = get_class.new
    render :partial => 'template/form', :locals => { :object => item, :action => 'create' }
  end
  
  #set conditions for list
  def set_conditions
    session[list_condition_key] = MyAdmin.prepare_conditions(params[:quick_search], get_class)
    session[list_quick_search_key] = params[:quick_search]
    session[list_page_num_key] = nil
    update_list        
  end
  
  #clear conditions for list
  def clear_conditions
    session[list_condition_key] = session[list_quick_search_key] = nil    
    update_list    
  end
  
  def set_page
    if params[:page_num]
      session[list_page_num_key] = params[:page_num]
      update_list
    end
  end
  
  #set order for list
  def set_order
    if params[:column]
      if get_order && get_order.index(params[:column])
        if get_order.index("ASC")
          session[list_order_key] = get_order.gsub(/ASC/,"DESC")
        elsif get_order.index("DESC")
          session[list_order_key] = get_order.gsub(/DESC/,"ASC")
        end        
      else
        session[list_order_key] = "#{params[:column]} ASC"        
      end
      update_list
    end    
  end
  
  def clear_advanced_conditions
    session[list_advanced_condition_key] = nil
    update_list
  end
  
    
  protected
  
  def addition_condition
    session["addition_condition_#{MyAdmin.get_name_by_type(get_class)}"]
  end
  
  def list_advanced_condition_key
    (MyAdmin.get_name_by_type(get_class) + '_list_advanced_condition').to_sym
  end
  
  def set_object_type
    @object_name = self.class.name.gsub('Admin::','').gsub('Controller','')
  end
  
  def get_class
    Object.const_get(@object_name)
  end
  
  def page_size
    10
  end
  
  def update_list
    type, items, paginator = get_params_for_list
    render :update do |page|
      page["list_#{MyAdmin.get_name_by_type(type)}"].replace :partial => 'template/list',
        :locals => { :type => type, :items => items, :paginator => paginator }
    end
  end
  
  private
  
  def get_items
    get_class.find(:all, :conditions => get_conditions,
      :order => get_order, :limit => page_size, :offset => get_offset)
  end
  
  def get_conditions
    condition = ""
    [get_list_conditions, get_advanced_conditions, addition_condition].each { |item| 
      condition += "#{item} AND " if item
    }
    condition += "TRUE"
  end
  
  def get_list_conditions
    session[list_condition_key]
  end
  
  def get_advanced_conditions
    session[list_advanced_condition_key]
  end
  
  def get_order
    session[list_order_key]
  end
  
  def get_offset
    session[list_page_num_key] ? ( session[list_page_num_key].to_i - 1 ) * page_size : 0    
  end
  
  def list_page_num_key
    (MyAdmin.get_name_by_type(get_class) + '_list_page').to_sym
  end
  
  def list_condition_key
    (MyAdmin.get_name_by_type(get_class) + '_list_condition').to_sym
  end
  
  def list_order_key
    (MyAdmin.get_name_by_type(get_class) + '_list_order').to_sym
  end
  
  def list_quick_search_key
    (MyAdmin.get_name_by_type(get_class) + '_quick_search').to_sym
  end
  
  #return type, items, number, page_num
  def get_params_for_list
    type = get_class
    items = get_items
    count = get_class.count :conditions => get_conditions
    aver = count != 0 ? count.to_f / page_size : 0
    number = aver != 0 && aver % 1 > 0 ? aver.to_i + 1 : aver.to_i
    page_num = session[list_page_num_key] || 1
    return type, items, Paginator::AdminPaginator.new(page_num, number, 10, type)
  end
  
end
