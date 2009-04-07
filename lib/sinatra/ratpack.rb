module Sinatra
  module Ratpack
    def self.registered(app)
      app.helpers RatPack::Tag
      app.helpers RatPack::HtmlHelpers  
      app.helpers RatPack::Forms
    end
  end
  
  register Ratpack
end # Sinatra