module RatPack
  module Forms
    # def error_messages_for(obj = nil, opts = {})
    #   current_form_context.error_messages_for(obj, opts[:error_class] || "error", 
    #     opts[:build_li] || "<li>%s</li>", 
    #     opts[:header] || "<h2>Form submission failed because of %s problem%s</h2>",
    #     opts.key?(:before) ? opts[:before] : true)
    # end
    
    %w(text password hidden file).each do |kind|
      self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{kind}_field(attrs)
          update_unbound_controls(attrs, "#{kind}")
          label = "#{kind}" == "hidden" ? "" : unbound_label(attrs)
          label + self_closing_tag(:input, {:type => "#{kind}"}.merge(attrs))
        end
      RUBY
    end

    def check_box(attrs)
      update_unbound_controls(attrs, "checkbox")
      if attrs.delete(:boolean)
        on, off = attrs.delete(:on), attrs.delete(:off)
        unbound_hidden_field(:name => attrs[:name], :value => off) <<
          self_closing_tag(:input, {:type => "checkbox", :value => on}.merge(attrs)) + unbound_label(attrs)
      else
        self_closing_tag(:input, {:type => "checkbox"}.merge(attrs)) + unbound_label(attrs)
      end
    end

    def radio_button(attrs)
      update_unbound_controls(attrs, "radio")
      self_closing_tag(:input, {:type => "radio"}.merge(attrs)) + unbound_label(attrs)
    end
    
    def radio_group(arr, attrs = {})
      arr.map do |ind_attrs|
        ind_attrs = {:value => ind_attrs} unless ind_attrs.is_a?(Hash)
        joined = attrs.merge(ind_attrs)
        joined.merge!(:label => joined[:label] || joined[:value])
        radio_button(joined)
      end.join
    end
    
    def text_area(contents, attrs)
      update_unbound_controls(attrs, "text_area")
      unbound_label(attrs) + tag(:textarea, contents, attrs)
    end
    
    def label(contents, attrs = {})
      if contents
        if contents.is_a?(Hash)
          label_attrs = contents
          contents = label_attrs.delete(:title)
        else
          label_attrs = attrs
        end
        tag(:label, contents, label_attrs)
      else
        ""
      end
    end
    
    def select(attrs = {})
      update_unbound_controls(attrs, "select")
      attrs[:name] << "[]" if attrs[:multiple] && !(attrs[:name] =~ /\[\]$/)
      tag(:select, options_for(attrs), attrs)
    end
    
    def button(contents, attrs)
      update_unbound_controls(attrs, "button")
      tag(:button, contents, attrs)
    end

    def submit(value, attrs)
      attrs[:type]  ||= "submit"
      attrs[:name]  ||= "submit"
      attrs[:value] ||= value
      update_unbound_controls(attrs, "submit")
      self_closing_tag(:input, attrs)
    end
    
    # def form(attrs = {}, &blk)
    #   captured = @origin.capture(&blk)
    #   fake_method_tag = process_form_attrs(attrs)
    #   tag(:form, fake_method_tag + captured, attrs)
    # end
    # 
    # def fieldset(attrs, &blk)
    #   captured = @origin.capture(&blk)
    #   legend = (l_attr = attrs.delete(:legend)) ? tag(:legend, l_attr) : ""
    #   tag(:fieldset, legend + captured, attrs)
    # end
    
    private

    def process_form_attrs(attrs)
      method = attrs[:method] || :post
      attrs[:enctype] = "multipart/form-data" if attrs.delete(:multipart) || @multipart
      method == :post || method == :get ? "" : fake_out_method(attrs, method)
    end

    # This can be overridden to use another method to fake out methods
    def fake_out_method(attrs, method)
      self_closing_tag(:input, :type => "hidden", :name => "_method", :value => method)
    end
    
    def update_unbound_controls(attrs, type)
      case type
      when "checkbox"
        update_unbound_check_box(attrs)
      when "radio"
        update_unbound_radio_button(attrs)
      when "file"
        @multipart = true
      when "text","password"
        attrs[:class] = "text"
      end

      attrs[:disabled] ? attrs[:disabled] = "disabled" : attrs.delete(:disabled)
    end
    
    def unbound_label(attrs = {})
      if attrs[:id]
        label_attrs = {:for => attrs[:id]}
      elsif attrs[:name]
        label_attrs = {:for => attrs[:name]}
      else
        label_attrs = {}
      end

      label_option = attrs.delete(:label)
      if label_option.is_a? Hash
        label(label_attrs.merge(label_option))
      else
        label(label_option, label_attrs)
      end
    end
    
    def update_unbound_check_box(attrs)
      boolean = attrs[:boolean] || (attrs[:on] && attrs[:off]) ? true : false

      case
      when attrs.key?(:on) ^ attrs.key?(:off)
        raise ArgumentError, ":on and :off must be specified together"
      when (attrs[:boolean] == false) && (attrs.key?(:on))
        raise ArgumentError, ":boolean => false cannot be used with :on and :off"
      when boolean && attrs.key?(:value)
        raise ArgumentError, ":value can't be used with a boolean checkbox"
      end

      if attrs[:boolean] = boolean
        attrs[:on] ||= "1"; attrs[:off] ||= "0"
      end

      attrs[:checked] = "checked" if attrs.delete(:checked)
    end

    def update_unbound_radio_button(attrs)
      attrs[:checked] = "checked" if attrs.delete(:checked)
    end
    
    def options_for(attrs)
      blank, prompt = attrs.delete(:include_blank), attrs.delete(:prompt)
      b = blank || prompt ? tag(:option, prompt || "", :value => "") : ""

      # yank out the options attrs
      collection, selected, text_method, value_method = 
        attrs.extract!(:collection, :selected, :text_method, :value_method)

      # if the collection is a Hash, optgroups are a-coming
      if collection.is_a?(Hash)
        ([b] + collection.map do |g,col|
          tag(:optgroup, options(col, text_method, value_method, selected), :label => g)
        end).join
      else
        options(collection || [], text_method, value_method, selected, b)
      end
    end

    def options(col, text_meth, value_meth, sel, b = nil)
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