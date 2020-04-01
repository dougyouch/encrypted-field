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

    def prefix_with_policy_name?
      options.fetch(:prefix_with_policy_name, true)
    end

    private

    def encode_payload(str)
      if options.key?(:encode_payload)
        options[:encode_payload].call(str)
      else
        Base64.strict_encode64(str)
      end
    end

    def decode_payload(str)
      if options.key?(:decode_payload)
        options[:decode_payload].call(str)
      else
        Base64.strict_decode64(str)
      end
    end

    def encode_iv(str)
      if options.key?(:encode_iv)
        options[:encode_iv].call(str)
      else
        Base64.strict_encode64(str)
      end
    end

    def decode_iv(str)
      if options.key?(:decode_iv)
        options[:decode_iv].call(str)
      else
        Base64.strict_decode64(str)
      end
    end

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
