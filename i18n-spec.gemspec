require_relative "lib/i18n-spec/version"

Gem::Specification.new do |s|
  s.name = "i18n-spec"
  s.version = I18nSpec::VERSION

  s.required_ruby_version = ">= 2.3.0"
  s.require_paths = ["lib"]
  s.authors = ["Christopher Dell"]
  s.date = "2014-10-27"
  s.description = "Includes a number of rspec matchers to make specing your locale files easy peasy."
  s.email = "chris@tigrish.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = Dir["lib/**/*.rb"]
  s.homepage = "http://github.com/tigrish/i18n-spec"
  s.licenses = ["MIT"]
  s.summary = "Matchers for specing locale files"

  s.add_runtime_dependency(%q<iso>, [">= 0"])
  s.add_development_dependency(%q<bundler>, [">= 0"])
end

