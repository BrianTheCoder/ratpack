module Sinatra
  module Helpers
    def self.registered(app)
      app.helpers RatPack::Tag
      app.helpers RatPack::HtmlHelpers  
      app.helpers RatPack::Forms
    end
  end
  
  register Helpers
end # Sinatra