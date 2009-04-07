module Sinatra
  module Ratpack
    module Helpers
      include RatPack::Tag
      include RatPack::HtmlHelpers  
      include RatPack::Forms
      include RatPack::Routes
    end
    
    def self.registered(app)
      puts 'loading ratpack'
      app.helpers Helpers
    end
  end
  
  register Ratpack
end # Sinatra