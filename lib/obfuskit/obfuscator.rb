# frozen_string_literal: true

# A class representing an obfuscator.

module Obfuskit
  class Obfuscator

    attr_reader :salt

    # Initializes the obfuscator with a string.
    # The string is converted to an array of bytes and stored in @c.
    # The size of the array is stored in @l.
    def initialize(salt)
      salt = salt.bytes if salt.is_a? String
      @salt = salt
      @length = @salt.size
    end

    # Obfuscates a string.
    # The string is converted to an array of bytes and each element is XORed with an element from @c.
    # The index of the element from @c is the index of the element from the string modulo @l.
    def obfuscate(value)
      value.bytes.map.with_index { |b, i| b ^ @salt[i % @length] }
    end

    # Reverses the obfuscation of an array of bytes.
    # Each element is XORed with an element from @c and the result is converted back to a string.
    # The index of the element from @c is the index of the element from the array modulo @l.
    def reveal(value)
      value.map.with_index { |b, i| b ^ @salt[i % @length] }.pack('C*').force_encoding('utf-8')
    end
  end
end