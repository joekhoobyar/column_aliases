$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "column_aliases/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "column_aliases"
  s.version     = ColumnAliases::VERSION
  s.authors     = ["Joe Khoobyar"]
  s.email       = ["joe@khoobyar.name"]
  s.homepage    = "http://joe.khoobyar.name"
  s.summary     = "ActiveRecord plugin to support column aliases"
  s.description = "ActiveRecord plugin to support column aliases"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "activerecord", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rails", "~> 3.2.13"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
