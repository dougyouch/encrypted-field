# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::PolicyWithIV all the logic required to encrypt/decrypt data using symmetric encryption.
  class PolicyWithIV < BasePolicy
    DEFAULT_SEPARATOR = '.'

    def encrypt(str)
      cipher = create_cipher.encrypt
      cipher.key = secret_key
      iv = cipher.random_iv
      encrypted_str = cipher.update(str) << cipher.final
      Base64.strict_encode64(iv) << separator << Base64.strict_encode64(encrypted_str)
    end

    def decrypt(encrypted_str)
      iv, encrypted_str = encrypted_str.split(separator, 2)
      cipher = create_cipher.decrypt
      cipher.key = secret_key
      cipher.iv = Base64.strict_decode64(iv)
      cipher.update(Base64.strict_decode64(encrypted_str) << cipher.final)
    end

    def separator
      options[:separator] || DEFAULT_SEPARATOR
    end
  end
end
