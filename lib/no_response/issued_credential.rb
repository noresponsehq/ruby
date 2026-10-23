# typed: true
# frozen_string_literal: true

# Hash an API key your platform issued. Hand-written beside the generated client.

require 'digest'

module NoResponse
  module IssuedCredential
    # SHA-256 of an issued API key, as 64 lower-case hex characters. The key
    # never leaves your backend: send only this hash, as
    # issued_credential.sha256 on the assessment request. The key is hashed as
    # its UTF-8 bytes exactly as given, with no trimming or normalisation.
    # Raises ArgumentError for a nil or empty key.
    def self.sha256(key)
      raise ArgumentError, 'issued key must be a non-empty string' unless key.is_a?(String) && !key.empty?

      Digest::SHA256.hexdigest(key.dup.force_encoding(Encoding::UTF_8))
    end
  end
end
