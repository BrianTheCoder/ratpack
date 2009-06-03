module RatPack
  module HtmlHelpers  
    def pluralize(str,num)
      num.to_i > 1 ? str.plural : str.singular
    end
      
    def link_to(name, url, options = {})
      defaults = {:href => url}
      tag(:a,name,defaults.merge(options))
    end
    
    def image_tag(file,attrs = {})
      file = "/images/#{file}" unless remote_asset?(file)
      defaults = {:src => file }  
      self_closing_tag(:img,defaults.merge(options))
    end

    def css_link(name, options = {})
      name = "/stylesheets/#{name}.css" unless remote_asset?(name)
      defaults = {:href => name, :media => "screen",
        :rel => "stylesheet", :type => "text/css"}
      self_closing_tag(:link,defaults.merge(options))
    end

    def js_link(name, options = {})
      name = "/javascripts/#{name}.js" unless remote_asset?(name)
      defaults = {:src => name, :type => "text/javascript"}
      tag(:script,defaults.merge(options))
    end
    
    def partial(template, opts = {})
      engine = opts.delete(:template) || :erb
      opts.merge!(:layout => false)
      path = :"partials/#{template}"
      if collection = opts.delete(:collection) then
        collection.map do |member|
          send(engine,path, opts.merge(:locals => {template.to_sym => member}))
        end.join("\n")
      else
        send(engine,path, opts)
      end
    end
    
    private
    
    def remote_asset?(uri)
      uri =~ %r[^\w+://.+]
    end
  end
end