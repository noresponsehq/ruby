# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # At least one of email, username or phone. name and ip refine the match and travel beside a lookup identifier; a body with only name or ip is refused with 400.
      class AssessmentRequestIdentifiers
        extend T::Sig
        include Crystalline::MetadataFields

        # One address: a 1 to 64 character local part without whitespace, angle brackets, control or invisible characters, '@', and a domain with a letter TLD. Send an internationalised domain in punycode. Nothing is trimmed. The local part keeps its case and the domain is lower-cased; no alias rewriting ('+tag', dots or provider heuristics) is applied.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The handle the account is signing up with: 1 to 64 characters, no whitespace, control or invisible characters, and not a credential hash or token. Echoed as received; compared case-insensitively.
        field(
          :username,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )
        # Strict E.164: '+', then 8 to 15 digits, the first not 0, with no separators. Phone evidence is gathered asynchronously, so a phone-only request answers 202 pending and the phone is listed in incomplete_sources on the synchronous answer.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # The full name as the user typed it, 1 to 128 characters with no control or invisible characters. It is searched in breach data and matched against names in the evidence. A row holding the signup's own email or username confirms the name; rows sharing another identifier add to the identity's history.
        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # The account_creation's client IP address: an IPv4 dotted quad without leading zeros, or an IPv6 address in its RFC 5952 text form (lower case, no leading zeros, the longest zero run compressed). Send an IPv4 client as a dotted quad, not IPv4-mapped. No zone, port or prefix. The server refuses a non-canonical IPv6 spelling, and every private, loopback, link-local, multicast, documentation or otherwise reserved address (the IANA special-purpose registries), with 400: only a public address says anything about a signup.
        field(
          :ip,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ip")}}
        )

        sig {
          params(
            email: T.nilable(::String),
            username: T.nilable(::String),
            phone: T.nilable(::String),
            name: T.nilable(::String),
            ip: T.nilable(::String)
          )
            .void
        }
        def initialize(email: nil, username: nil, phone: nil, name: nil, ip: nil)
          @email = email
          @username = username
          @phone = phone
          @name = name
          @ip = ip
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @email == other.email
          return false unless @username == other.username
          return false unless @phone == other.phone
          return false unless @name == other.name
          return false unless @ip == other.ip
          true
        end
      end
    end
  end
end
