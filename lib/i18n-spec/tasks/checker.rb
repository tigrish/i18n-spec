require 'i18n-spec'

I18nSpec::LOG_DETAIL_PREDICATE = " | - "

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
        log :fatal, 'could not be parsed', format_str(locale_file.errors[:unparseable])
        fatals += 1
        break
      end

      unless locale_file.invalid_pluralization_keys.empty?
        log :error, 'invalid pluralization keys', format_array(locale_file.errors[:invalid_pluralization_keys])
        errors += 1
      end

      puts '[OK]' if fatals + errors + warnings == 0
    end

    puts "="*80
  end

  def log(level, msg, detail=nil)
    puts " - [" << level.to_s.upcase << '] ' << msg 
    puts detail if detail
  end

  def format_array(array)
    [I18nSpec::LOG_DETAIL_PREDICATE, array.join(I18nSpec::LOG_DETAIL_PREDICATE)].join
  end

  def format_str(str)
    [I18nSpec::LOG_DETAIL_PREDICATE, str].join
  end
end