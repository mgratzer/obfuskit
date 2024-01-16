# A class representing an obfuscator.
class O
    # Initializes the obfuscator with a string.
    # The string is converted to an array of bytes and stored in @c.
    # The size of the array is stored in @l.
    def initialize(s)
      s = s.bytes if s.is_a? String
      @c = s
      @l = @c.size
    end
  
    # Obfuscates a string.
    # The string is converted to an array of bytes and each element is XORed with an element from @c.
    # The index of the element from @c is the index of the element from the string modulo @l.
    def o(v)
      v.bytes.map.with_index { |b, i| b ^ @c[i % @l] }
    end
  
    # Reverses the obfuscation of an array of bytes.
    # Each element is XORed with an element from @c and the result is converted back to a string.
    # The index of the element from @c is the index of the element from the array modulo @l.
    def r(value)
      value.map.with_index { |b, i| b ^ @c[i % @l] }.pack('C*').force_encoding('utf-8')
    end
  end