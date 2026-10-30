# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One online-account search of the signup's email or username, detailed view only. name and domain name the platform searched, not a provider. outcome is the search's signal outcome: found, not_found, or a failure (blocked, unavailable, inconclusive) with its reason; a failure is not reported as not_found. The members after reason are what the platform returned beside an account it found, each absent when it did not say.
      class OnlineAccount
        extend T::Sig
        include Crystalline::MetadataFields

        # The platform's name, such as Adobe or GitHub.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # The platform's domain, lower case: the host its logo is fetched for.
        field(
          :domain,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("domain"), required: true}}
        )

        field(
          :identifier,
          Models::Shared::Identifier,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Identifier, false)
            }
          }
        )
        # Per-signal outcome. A source that timed out, was blocked or errored reports blocked, unavailable or inconclusive with a reason and is listed in incomplete_sources; not_found is a definite absence.
        field(
          :outcome,
          Models::Shared::SignalOutcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SignalOutcome, false)
            }
          }
        )
        # Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::FailureReason),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FailureReason, true)
            }
          }
        )
        # How the account signs in, as the platform reports it, sorted: a password, a Google, Facebook, Apple or Microsoft account, the organisation's single sign-on, or another method.
        field(
          :sign_in,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::SignIn)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sign_in")}}
        )
        # Whether the platform says the account's email is verified.
        field(
          :email_verified,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email_verified")}}
        )
        # Whether the platform says the account is blocked or suspended.
        field(
          :blocked,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("blocked")}}
        )
        # personal, or business: an account a company or school manages.
        field(
          :account_type,
          Crystalline::Nilable.new(Models::Shared::AccountType),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("account_type"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountType, true)
            }
          }
        )
        # Whether the account has its own profile picture rather than the platform's default. The picture is not returned.
        field(
          :has_avatar,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("has_avatar")}}
        )
        # The first letters of the account holder's first name, as the platform shows them (Life360 shows two and hides the rest). It is evidence only: it does not change the score or the consistency results.
        field(
          :first_name_prefix,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("first_name_prefix")}}
        )

        sig {
          params(
            name: ::String,
            domain: ::String,
            identifier: Models::Shared::Identifier,
            outcome: Models::Shared::SignalOutcome,
            reason: T.nilable(Models::Shared::FailureReason),
            sign_in: T.nilable(T::Array[Models::Shared::SignIn]),
            email_verified: T.nilable(T::Boolean),
            blocked: T.nilable(T::Boolean),
            account_type: T.nilable(Models::Shared::AccountType),
            has_avatar: T.nilable(T::Boolean),
            first_name_prefix: T.nilable(::String)
          )
            .void
        }
        def initialize(
          name:,
          domain:,
          identifier:,
          outcome:,
          reason: nil,
          sign_in: nil,
          email_verified: nil,
          blocked: nil,
          account_type: nil,
          has_avatar: nil,
          first_name_prefix: nil
        )
          @name = name
          @domain = domain
          @identifier = identifier
          @outcome = outcome
          @reason = reason
          @sign_in = sign_in
          @email_verified = email_verified
          @blocked = blocked
          @account_type = account_type
          @has_avatar = has_avatar
          @first_name_prefix = first_name_prefix
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @domain == other.domain
          return false unless @identifier == other.identifier
          return false unless @outcome == other.outcome
          return false unless @reason == other.reason
          return false unless @sign_in == other.sign_in
          return false unless @email_verified == other.email_verified
          return false unless @blocked == other.blocked
          return false unless @account_type == other.account_type
          return false unless @has_avatar == other.has_avatar
          return false unless @first_name_prefix == other.first_name_prefix
          true
        end
      end
    end
  end
end
