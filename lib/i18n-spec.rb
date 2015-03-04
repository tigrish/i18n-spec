if defined?(Psych) and defined?(Psych::VERSION) and !defined?(YAML::ParseError)
  YAML::ParseError = Psych::SyntaxError
end

require 'rspec/core'
require 'iso'
require 'yaml'
require 'i18n-spec/failure_message'
require 'i18n-spec/interpolation_cheker'
Dir[File.dirname(__FILE__) + '/i18n-spec/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/i18n-spec/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/i18n-spec/matchers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/i18n-spec/shared_examples/*.rb'].each {|file| require file }
