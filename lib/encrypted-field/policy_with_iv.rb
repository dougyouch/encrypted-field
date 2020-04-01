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
      encode_iv(iv) << separator << encode_payload(encrypted_str)
    end

    def decrypt(encrypted_str)
      iv, encrypted_str = encrypted_str.split(separator, 2)
      cipher = create_cipher.decrypt
      cipher.key = secret_key
      cipher.iv = decode_iv(iv)
      cipher.update(decode_payload(encrypted_str) << cipher.final)
    end

    def separator
      options[:separator] || DEFAULT_SEPARATOR
    end
  end
end
