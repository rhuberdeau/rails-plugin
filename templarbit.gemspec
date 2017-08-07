$:.push File.expand_path("../lib", __FILE__)

require "templarbit/version"

Gem::Specification.new do |s|
  s.name        = "templarbit"
  s.version     = Templarbit::VERSION
  s.authors     = ["Templarbit Inc."]
  s.email       = ["hello@templarbit.com"]
  s.homepage    = "https://github.com/templarbit/rails-plugin"
  s.summary     = "Stop XSS attacks."
  s.description = "The most effective way to protect applications from malicious activity."
  s.license     = "GNU General Public License v3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"

  # TODO: we can probably remove this dep
  s.add_development_dependency "sqlite3"
end
