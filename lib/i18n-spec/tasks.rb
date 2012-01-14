require 'i18n-spec'

I18nSpec::LOG_DETAIL_PREDICATE = "  - "

namespace :'i18n-spec' do
  desc "Checks the validity of a locale file"
  task :validate do
    if ARGV[1].nil?
      puts "You must specifiy a file path or a folder path"
      return
    elsif File.directory?(ARGV[1])
      filepaths = Dir.glob("#{ARGV[1]}/*.yml")
    else
      filepaths = [ARGV[1]]
    end

    filepaths.each do |filepath|
      heading filepath
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

      log :ok if fatals + errors + warnings == 0
    end
  end

  desc "Checks for missing translations between the default and the translated locale file"
  task :completeness do
    if ARGV[1].nil? || ARGV[2].nil?
      puts "You must specify a default locale file and translated file or a folder of translated files"
    elsif File.directory?(ARGV[2])
      translated_filepaths = Dir.glob("#{ARGV[2]}/*.yml")
    else
      translated_filepaths = [ARGV[2]]
    end
    default_locale = I18nSpec::LocaleFile.new(ARGV[1])
    translated_filepaths.each do |translated_filepath|
      heading translated_filepath
      locale_file = I18nSpec::LocaleFile.new(translated_filepath)
      misses = default_locale.flattened_translations.keys.reject do |key|
        locale_file.flattened_translations.keys.include?(key)
      end
      if misses.empty?
        log :complete
      else
        misses.each { |miss| log :missing, miss }
      end
    end
  end

  def log(level, msg='', detail=nil)
    puts "- *" << level.to_s.upcase << '* ' << msg 
    puts detail if detail
  end

  def heading(str='')
    puts "\n### " << str << "\n\n"
  end

  def format_array(array)
    [I18nSpec::LOG_DETAIL_PREDICATE, array.join(I18nSpec::LOG_DETAIL_PREDICATE)].join
  end

  def format_str(str)
    [I18nSpec::LOG_DETAIL_PREDICATE, str].join
  end
end