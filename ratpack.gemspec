# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ratpack}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["brianthecoder"]
  s.date = %q{2009-04-12}
  s.email = %q{wbsmith83@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/ratpack.rb",
    "lib/ratpack/core_ext/hash.rb",
    "lib/ratpack/forms.rb",
    "lib/ratpack/html_helpers.rb",
    "lib/ratpack/routes.rb",
    "lib/ratpack/tag.rb",
    "lib/sinatra/ratpack.rb",
    "test/ratpack_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/BrianTheCoder/ratpack}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A collection of helpers I wanted for sinatra, thought I'd share}
  s.test_files = [
    "test/ratpack_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
