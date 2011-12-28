require 'i18n-spec'

namespace :i18n do
  desc "Checks the validity of a locale file"
  task :check do
    

    if ARGV[1].nil?
      puts "You must specifiy a file path or a folder path"
      return
    elsif File.directory?(ARGV[1])
      filepaths = Dir.glob("#{ARGV[1]}/*.yml")
    else
      filepaths = [ARGV[1]]
    end

    filepaths.each do |filepath|
      puts "-"*80
      puts filepath

      fatals, errors, warnings = [0, 0, 0]
      locale_file = I18nSpec::LocaleFile.new(filepath)

      unless locale_file.is_parseable?
        log :fatal, 'could not be parsed'
        fatals += 1
        break
      end

      unless (details = locale_file.invalid_pluralization_keys).empty?
        log :error, 'invalid pluralization keys', format_array(details)
        errors += 1
      end

      puts '[OK]' if fatals + errors + warnings == 0
    end

    puts "="*80
  end
end

def log(level, msg, detail=nil)
  puts " - [" << level.to_s.upcase << ']: ' << msg 
  puts detail if detail
end

def format_array(array)
  predicate = " | - "
  predicate << array.join(predicate)
end