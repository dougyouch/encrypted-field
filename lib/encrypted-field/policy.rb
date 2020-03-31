# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::Policy all the logic required to encrypt/decrypt data using symmetric encryption.
  class Policy
    DEFAULT_SEPARATOR = '.'

    attr_reader :algorithm,
                :separator

    def initialize(algorithm, secret_key, separator = DEFAULT_SEPARATOR)
      @algorithm = algorithm
      @separator = separator
      @secret_key = secret_key
    end

    def encrypt(str)
      cipher = create_cipher.encrypt
      cipher.key = secret_key
      iv = cipher.random_iv
      encrypted_str = cipher.update(str)
      encrypted_str << cipher.final
      Base64.strict_encode64(iv) + separator + Base64.strict_encode64(encrypted_str)
    end

    def decrypt(encrypted_str)
      iv, encrypted_str = encrypted_str.split(separator, 2)
      cipher = create_cipher.decrypt
      cipher.key = secret_key
      cipher.iv = Base64.strict_decode64(iv)
      str = cipher.update(Base64.strict_decode64(encrypted_str))
      str << cipher.final
      str
    end

    def random_key
      create_cipher.random_key
    end

    private

    def create_cipher
      OpenSSL::Cipher.new(algorithm)
    end

    def secret_key
      case @secret_key
      when Proc
        @secret_key.call
      when String
        @secret_key
      end
    end
  end
end
