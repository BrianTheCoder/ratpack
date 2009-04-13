module RatPack
  module Tag    
    def tag(name, contents = nil, attrs = {}, &block)
      attrs, contents = contents, nil if contents.is_a?(Hash)
      # contents = capture(&block) if block_given?
      open_tag(name, attrs) + contents.to_s + close_tag(name)
    end

    def open_tag(name, attrs = nil)
      "<#{name}#{' ' + attrs.to_html_attributes unless attrs.blank?}>"
    end
  
    def close_tag(name)
      "</#{name}>"
    end
  
    def self_closing_tag(name, attrs = nil)
      "<#{name}#{' ' + attrs.to_html_attributes if attrs && !attrs.empty?}/>"
    end 
  end
end