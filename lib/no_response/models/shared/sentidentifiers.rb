# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The identifiers an assessment was sent: each member of the request's identifiers object exactly as received, before the server normalised it (the email domain keeps its case, the name its Unicode form). A member the request did not send is absent. NoResponse keeps them encrypted under the workspace's own key, does not index or log them, and deletes them with the assessment: on DELETE of the assessment or its account, at its expires_at, and with the workspace.
      class SentIdentifiers
        extend T::Sig
        include Crystalline::MetadataFields

        # identifiers.email as the request sent it.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # identifiers.username as the request sent it.
        field(
          :username,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )
        # identifiers.phone as the request sent it.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # identifiers.name as the request sent it, before NFC normalisation.
        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # identifiers.ip as the request sent it.
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
