# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::BasePolicy abstract class for creating encryption policies
  class BasePolicy
    attr_reader :algorithm,
                :options

    def initialize(algorithm, secret_key, options = {})
      @algorithm = algorithm
      @secret_key = secret_key
      @options = options
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
