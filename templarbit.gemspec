$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "templarbit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "templarbit"
  s.version     = Templarbit::VERSION
  s.authors     = ["Matthias Kadenbach"]
  s.email       = ["matthias.kadenbach@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Templarbit."
  s.description = "TODO: Description of Templarbit."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"

  s.add_development_dependency "sqlite3"
end
