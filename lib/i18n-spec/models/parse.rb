module I18nSpec
  class Parse

    def self.for_interpolation_variables(str)
      return nil if str.nil?
      str.scan(/%{[^%{}]*}/)
    end

  end
end