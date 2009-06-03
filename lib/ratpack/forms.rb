module RatPack
  module Forms
    def error_messages_for(obj = nil, opts = {})
      return unless obj.respond_to?(:errors)
      return if obj.errors.blank?
      html = tag(:h2, "Form submission failed because of #{obj.errors.size} #{pluralize("error",obj.errors.size)}")
      msgs = obj.errors.map{|error| error.map{|msg| tag(:li,msg)}}.flatten
      tag(:div, html + tag(:ul,msgs), :class => "error")
    end
    
    %w(text password hidden file).each do |kind|
      self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{kind}_field(attrs)
          attrs[:class] = "text" if %w(text password).include?("#{kind}") && !attrs.has_key?(:class)         
          closed_form_field(:input, {:type => "#{kind}"}.merge(attrs))
        end
      RUBY
    end
    
    def text_area(attrs = {})
      form_field(:textarea, attrs.delete(:value) || "", attrs)
    end
    
    def button(contents, attrs = {})
      form_field(:button, contents, attrs)
    end
    
    def radio_button(attrs)
      closed_form_field(:input, {:type => "radio"}.merge(attrs))
    end
    
    def radio_group(arr, attrs = {})
      arr.map do |ind_attrs|
        ind_attrs = {:value => ind_attrs} unless ind_attrs.is_a?(Hash)
        joined = attrs.merge(ind_attrs)
        radio_button(joined)
      end.join
    end
    
    def check_box(attrs)
      html = ""
      label = build_field(attrs)
      attrs[:checked] = "checked" if attrs[:checked]
      if attrs.delete(:boolean)
        on, off = attrs.delete(:on), attrs.delete(:off)
        html << hidden_field(:name => attrs[:name], :value => off)
        html << self_closing_tag(:input, {:type => "checkbox", :value => on}.merge(attrs))
      else
        closed_form_field(:input, {:type => "checkbox"}.merge(attrs))
        html << self_closing_tag(:input, {:type => "checkbox"}.merge(attrs))
      end
      html + label
    end
    
    def select(attrs = {})
      attrs[:name] << "[]" if attrs[:multiple] && !(attrs[:name] =~ /\[\]$/)
      form_field(:select, options_for(attrs), attrs)
    end
    
    def submit(value="Submit", attrs = {})
      attrs[:type]  ||= "submit"
      attrs[:name]  ||= "submit"
      attrs[:value] ||= value
      closed_form_field(:input, attrs)
    end
    
    def reset(value="Reset", attrs = {})
      attrs[:type]  ||= "reset"
      attrs[:name]  ||= "reset"
      attrs[:value] ||= value
      closed_form_field(:input, attrs)
    end
    
    private
    
    def form_field(type, content, attrs)
      attrs[:id] = sanitize_name(attrs[:name]) unless attrs.has_key?(:id)
      build_field(attrs) + tag(type, content, attrs)
    end
    
    def closed_form_field(type, attrs)
      attrs[:id] = sanitize_name(attrs[:name]) unless attrs.has_key?(:id)
      build_field(attrs) + self_closing_tag(type, attrs)
    end
    
    def sanitize_name(name)
      name.gsub(/\[\]$/,'').gsub(/(\[)(.+?)\]$/,'_\2')
    end
    
    def build_field(attrs)
      label = attrs.has_key?(:label) ? build_label(attrs) : ""
      hint = attrs.has_key?(:hint) ? tag(:div,attrs.delete(:hint), :class => "hint") : ""
      label + hint
    end
    
    def build_label(attrs)
      if attrs[:id]
        label_attrs = {:for => attrs[:id]}
      elsif attrs[:name]
        label_attrs = {:for => attrs[:name]}
      else
        label_attrs = {}
      end
      tag(:label, attrs.delete(:label), label_attrs)
    end
    
    def options_for(attrs)
      blank, prompt = attrs.delete(:include_blank), attrs.delete(:prompt)
      b = blank || prompt ? tag(:option, prompt || "", :value => "") : ""
      # yank out the options attrs
      collection, selected, text_method, value_method = attrs.extract!(:collection, :selected, :text_method, :value_method)
      # if the collection is a Hash, optgroups are a-coming
      if collection.is_a?(Hash)
        ([b] + collection.map do |g,col|
          tag(:optgroup, select_options(col, text_method, value_method, selected), :label => g)
        end).join
      else
        select_options(collection || [], text_method, value_method, selected, b)
      end
    end
    
    def select_options(col, text_meth, value_meth, sel, b = nil)
      ([b] + col.map do |item|
        text_meth = text_meth && item.respond_to?(text_meth) ? text_meth : :last
        value_meth = value_meth && item.respond_to?(value_meth) ? value_meth : :first
    
        text  = item.is_a?(String) ? item : item.send(text_meth)
        value = item.is_a?(String) ? item : item.send(value_meth)
    
        option_attrs = {:value => value}
        if sel.is_a?(Array)
          option_attrs.merge!(:selected => "selected") if value.in? sel
        else
          option_attrs.merge!(:selected => "selected") if value == sel
        end
        tag(:option, text, option_attrs)
      end).join
    end
  end
end