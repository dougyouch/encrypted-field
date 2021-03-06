# frozen_string_literal: true

module EncryptedField
  # EncryptedField::Field adds the plain text methods to the class.
  # Useful for hard coding the policy_name to the field during class creation.
  class Field
    attr_reader :field_name,
                :encrypted_field_name,
                :policy_name,
                :fallback_policy_name

    def initialize(field_name, encrypted_field_name, policy_name, fallback_policy_name = nil)
      @field_name = field_name
      @encrypted_field_name = encrypted_field_name
      @policy_name = policy_name.to_s
      @fallback_policy_name = fallback_policy_name && fallback_policy_name.to_s
    end

    def add_methods(klass)
      klass.class_eval <<METHODS, __FILE__, __LINE__ + 1
def #{field_name}
  #{encrypted_field_name} && ::EncryptedField::Encoder.encoder.decrypt(#{encrypted_field_name}, #{fallback_policy_name.inspect})
end

def #{field_name}=(v)
  self.#{encrypted_field_name} = v && ::EncryptedField::Encoder.encoder.encrypt(v, #{policy_name.inspect})
end
METHODS
    end
  end
end
