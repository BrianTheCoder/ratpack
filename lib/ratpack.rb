require 'sinatra/base'
require 'extlib'

module RatPack
  VERSION = '0.0.1'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR

  def self.version
    VERSION
  end

  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end
end  # module VelvetRope

RatPack.require_all_libs_relative_to(__FILE__)