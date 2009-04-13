module Sinatra
  module RatPack
    def self.registered(app)
      app.helpers ::RatPack::Tag
      app.helpers ::RatPack::HtmlHelpers
      app.helpers ::RatPack::Routes
      app.helpers ::RatPack::Forms
    end
  end
  
  register RatPack
end # Sinatra