# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ReasonCode - A stable reason code. New codes may appear; ignore any you do not know.
      class ReasonCode
        include ::Crystalline::Enum
        enums do
          NO_DIGITAL_FOOTPRINT = new("no_digital_footprint")
          VOIP_NUMBER = new("voip_number")
          DISPOSABLE_EMAIL = new("disposable_email")
          NEW_EMAIL = new("new_email")
          SPAM_REPORTS = new("spam_reports")
          FRAUD_FLAG = new("fraud_flag")
          IDENTITY_MISMATCH = new("identity_mismatch")
          COUNTRY_MISMATCH = new("country_mismatch")
          PROXY_IP = new("proxy_ip")
          SEEN_BEFORE = new("seen_before")
          SHARED_IP = new("shared_ip")
          MANY_RECENT_SIGNUPS = new("many_recent_signups")
          ESTABLISHED_ACCOUNTS = new("established_accounts")
          AGED_IDENTITY = new("aged_identity")
          BREACH_NAME_MATCH = new("breach_name_match")
          BREACH_COOCCURRENCE = new("breach_cooccurrence")
          BREACH_NAME_MISMATCH = new("breach_name_mismatch")
          BREACH_PHONE_MISMATCH = new("breach_phone_mismatch")
          RECENT_PASSWORD_EXPOSURE = new("recent_password_exposure")
          CREDENTIAL_LIST_EXPOSURE = new("credential_list_exposure")
          ABUSE_ECOSYSTEM_MEMBER = new("abuse_ecosystem_member")
          NO_BREACH_HISTORY = new("no_breach_history")
          AUTOMATION_FAST_SUBMIT = new("automation_fast_submit")
          CLIENT_CLOCK_SKEW = new("client_clock_skew")
          BOT_OR_AUTOMATION = new("bot_or_automation")
          AUTH_EMAIL_VERIFIED = new("auth_email_verified")
          AUTH_PHONE_VERIFIED = new("auth_phone_verified")
          AUTH_MFA_RECENT = new("auth_mfa_recent")
          AUTH_NEW_SESSION = new("auth_new_session")
          AUTH_NEW_ACCOUNT = new("auth_new_account")
          AUTH_IMPERSONATED = new("auth_impersonated")
          CONTEXT_TIMEZONE_MISMATCH = new("context_timezone_mismatch")
          CONTEXT_LOCALE_MISMATCH = new("context_locale_mismatch")
          CONTEXT_LINE_COUNTRY_MISMATCH = new("context_line_country_mismatch")
          PRIOR_ABUSE_LINK = new("prior_abuse_link")
        end

        open!
      end
    end
  end
end
