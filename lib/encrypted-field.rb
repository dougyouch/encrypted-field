# frozen_string_literal: true

require 'encrypted-field/config'
require 'encrypted-field/encoder'
require 'encrypted-field/field'
require 'encrypted-field/policy'

# EncryptedField is a library for obfuscating and simplifying the logic around encrypting/decrypting values from a DB
module EncryptedField
  def self.included(base)
    base.extend ClassMethods
  end

  # no-doc
  module ClassMethods
    def encrypted_field(field_name, policy_name, encrypted_field_name = nil)
      encrypted_field_name ||= "#{field_name}_encrypted"
      Field.new(field_name, encrypted_field_name, policy_name).add_methods(self)
    end
  end
end
