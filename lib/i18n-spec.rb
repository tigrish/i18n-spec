Dir[File.dirname(__FILE__) + '/i18n-spec/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/i18n-spec/matchers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/i18n-spec/shared_examples/*.rb'].each {|file| require file }