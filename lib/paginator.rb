module Paginator
  
  class BasePaginator
    
    include MyAdmin
         
    attr_accessor :current_page, :total_pages, :span_page
    # additional options
    attr_accessor :type
  
    def initialize(current_page, total_pages, span_page = 10)
      @current_page, @total_pages, @span_page = 
        current_page, total_pages, span_page
    end
  
    def self.paginate(paginator, template)
      simply_paginate(paginator, template)
    end
  
    def self.simply_paginate(paginator, template)
      i = 1
      input = ''
      paginator.total_pages.times{
        if i != paginator.current_page.to_i
          input += template.link_to_remote("#{i}",
            :url => { :action => "set_page", :skip_relative_url_root=>true },
            :with => "'page_num=#{(i).to_s}'",
            :before => "$('loading_for_#{MyAdmin.get_name_by_type(paginator.type)}').show( )",
            :complete => "$('loading_for_#{MyAdmin.get_name_by_type(paginator.type)}').hide(  )")
        else
          input += "<span style=\"font-weight:lighter;\">#{i}</span>"
        end
        input += "|" if i < paginator.total_pages
        i += 1
      } if paginator.total_pages > 1
      input
    end
  
  end
  
  class AdminPaginator < BasePaginator
    
    def initialize(current_page, total_pages, span_page = 10, type = nil)
      super(current_page, total_pages, span_page)
      @type = type
    end
    
    def self.paginate(paginator, template)
      paginator.total_pages > 10 ? paginate3000(paginator, template) : simply_paginate(paginator, template)
    end
    
    def self.paginate3000(paginator, template)
      "<div class=\"paginator\" id=\"paginator_#{MyAdmin.get_name_by_type(paginator.type)}\"></div>
      <div class=\"paginator_pages\">#{paginator.total_pages} pages</div>
      <script type=\"text/javascript\">
          pag_#{MyAdmin.get_name_by_type(paginator.type)} = 
                        new Paginator('paginator_#{MyAdmin.get_name_by_type(paginator.type)}', 
                        #{paginator.total_pages}, #{paginator.span_page}, #{paginator.current_page}, 
                        \"#{template.remote_function(
                            :url => { :action => "set_page", :skip_relative_url_root=>true },
                            :with => "'page_num=*number'",
                            :before => "$('loading_for_#{MyAdmin.get_name_by_type(paginator.type)}').show()",
                            :complete => "$('loading_for_#{MyAdmin.get_name_by_type(paginator.type)}').hide()")}\");
      </script>"
    end
    
  end
end