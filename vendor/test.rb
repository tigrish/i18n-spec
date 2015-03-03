def check_interpolation(t1, t2, key = [])
  if t1.is_a? Hash
    t1.each do |(k, v)|
      key << k
      c = check_interpolation v, t2[k], key
      return c if c
    end
  elsif t2.is_a? Array
    t1.each_with_index do |v, i|
      key << i
      c = check_interpolation v, t2[i], key
      return c if c
    end
  else
    keys = get_interpolation_keys(t1) - get_interpolation_keys(t2)
    return [keys, t1, t2] unless keys.empty?
  end

  nil
end

def get_interpolation_keys(translation)
  translation.to_s.scan(/(?<!%)%\{([^\}]+)\}/).flatten
end


p check_interpolation(
  { a: { b: '%{a}' } },
  { a: { b: '%{aa}' } },
)
