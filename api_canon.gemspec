$:.push File.expand_path("../lib", __FILE__)
require "api_canon/version"

Gem::Specification.new do |s|
  s.name          = %q{api_canon}
  s.license       = "MIT"
  s.version       = ApiCanon::VERSION
  s.platform      = Gem::Platform::RUBY
  s.homepage      = %q{http://github.com/cwalsh/api_canon}
  s.authors       = ["Cameron Walsh"]
  s.email         = ["cameron.walsh@gmail.com"]
  s.description   = %q{api_canon is a declarative documentation generator
                       for APIs. Declare the parameters and response codes,
                       describe them, and give some example values. api_canon
                       handles the rest for you.}
  s.summary       = %q{Declarative documentation generator for APIs.}

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency("rails", ">= 2.3.17")
  s.add_development_dependency("rspec", "~> 2.13.0")
  s.add_development_dependency("rake")
end
