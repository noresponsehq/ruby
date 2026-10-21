# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PhoneEnrichmentFields
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )

        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )

        field(
          :carrier,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("carrier")}}
        )

        field(
          :line_type,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("line_type")}}
        )

        field(
          :entity_type,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("entity_type")}}
        )

        field(
          :country_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country_code")}}
        )

        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )

        field(
          :state,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("state")}}
        )

        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )

        field(
          :location,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("location")}}
        )

        field(
          :national_format,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("national_format")}}
        )

        field(
          :job_title,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("job_title")}}
        )

        field(
          :company_name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company_name")}}
        )

        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )

        field(
          :website,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("website")}}
        )

        field(
          :first_call_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("first_call_at")}}
        )

        field(
          :last_call_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_call_at")}}
        )

        field(
          :matched_name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_name")}}
        )

        field(
          :alternate_names,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::AlternateName,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("alternate_names")}}
        )

        field(
          :name_candidates,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::NameCandidate,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name_candidates")}}
        )

        field(
          :timezones,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::Timezone,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("timezones")}}
        )

        field(
          :emails,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::Email,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("emails")}}
        )

        field(
          :websites,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::Website,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("websites")}}
        )

        field(
          :locations,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::Location,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("locations")}}
        )

        field(
          :social_profiles,
          Crystalline::Nilable.new(
            Crystalline::Array.new(
              Crystalline::Union.new(
                ::String,
                ::Float,
                Crystalline::Boolean.new,
                Models::Shared::SocialProfile,
                Crystalline::Array.new(::Object)
              )
            )
          ),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("social_profiles")}}
        )

        field(
          :report_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("report_count")}}
        )

        field(
          :tag_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("tag_count")}}
        )

        field(
          :total_calls,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total_calls")}}
        )

        field(
          :calls_60_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("calls_60_days")}}
        )

        field(
          :reports_60_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reports_60_days")}}
        )

        field(
          :searches_60_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("searches_60_days")}}
        )

        field(
          :comment_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("comment_count")}}
        )

        field(
          :names_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("names_count")}}
        )

        field(
          :spam_report_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spam_report_count")}}
        )

        sig {
          params(
            phone: T.nilable(::String),
            name: T.nilable(::String),
            carrier: T.nilable(::String),
            line_type: T.nilable(::String),
            entity_type: T.nilable(::String),
            country_code: T.nilable(::String),
            country: T.nilable(::String),
            state: T.nilable(::String),
            city: T.nilable(::String),
            location: T.nilable(::String),
            national_format: T.nilable(::String),
            job_title: T.nilable(::String),
            company_name: T.nilable(::String),
            email: T.nilable(::String),
            website: T.nilable(::String),
            first_call_at: T.nilable(::String),
            last_call_at: T.nilable(::String),
            matched_name: T.nilable(::String),
            alternate_names: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::AlternateName, T::Array[::Object])]
            ),
            name_candidates: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::NameCandidate, T::Array[::Object])]
            ),
            timezones: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::Timezone, T::Array[::Object])]
            ),
            emails: T.nilable(T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::Email, T::Array[::Object])]),
            websites: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::Website, T::Array[::Object])]
            ),
            locations: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::Location, T::Array[::Object])]
            ),
            social_profiles: T.nilable(
              T::Array[T.any(::String, ::Float, T::Boolean, Models::Shared::SocialProfile, T::Array[::Object])]
            ),
            report_count: T.nilable(::Integer),
            tag_count: T.nilable(::Integer),
            total_calls: T.nilable(::Integer),
            calls_60_days: T.nilable(::Integer),
            reports_60_days: T.nilable(::Integer),
            searches_60_days: T.nilable(::Integer),
            comment_count: T.nilable(::Integer),
            names_count: T.nilable(::Integer),
            spam_report_count: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          phone: nil,
          name: nil,
          carrier: nil,
          line_type: nil,
          entity_type: nil,
          country_code: nil,
          country: nil,
          state: nil,
          city: nil,
          location: nil,
          national_format: nil,
          job_title: nil,
          company_name: nil,
          email: nil,
          website: nil,
          first_call_at: nil,
          last_call_at: nil,
          matched_name: nil,
          alternate_names: nil,
          name_candidates: nil,
          timezones: nil,
          emails: nil,
          websites: nil,
          locations: nil,
          social_profiles: nil,
          report_count: nil,
          tag_count: nil,
          total_calls: nil,
          calls_60_days: nil,
          reports_60_days: nil,
          searches_60_days: nil,
          comment_count: nil,
          names_count: nil,
          spam_report_count: nil
        )
          @phone = phone
          @name = name
          @carrier = carrier
          @line_type = line_type
          @entity_type = entity_type
          @country_code = country_code
          @country = country
          @state = state
          @city = city
          @location = location
          @national_format = national_format
          @job_title = job_title
          @company_name = company_name
          @email = email
          @website = website
          @first_call_at = first_call_at
          @last_call_at = last_call_at
          @matched_name = matched_name
          @alternate_names = alternate_names
          @name_candidates = name_candidates
          @timezones = timezones
          @emails = emails
          @websites = websites
          @locations = locations
          @social_profiles = social_profiles
          @report_count = report_count
          @tag_count = tag_count
          @total_calls = total_calls
          @calls_60_days = calls_60_days
          @reports_60_days = reports_60_days
          @searches_60_days = searches_60_days
          @comment_count = comment_count
          @names_count = names_count
          @spam_report_count = spam_report_count
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @phone == other.phone
          return false unless @name == other.name
          return false unless @carrier == other.carrier
          return false unless @line_type == other.line_type
          return false unless @entity_type == other.entity_type
          return false unless @country_code == other.country_code
          return false unless @country == other.country
          return false unless @state == other.state
          return false unless @city == other.city
          return false unless @location == other.location
          return false unless @national_format == other.national_format
          return false unless @job_title == other.job_title
          return false unless @company_name == other.company_name
          return false unless @email == other.email
          return false unless @website == other.website
          return false unless @first_call_at == other.first_call_at
          return false unless @last_call_at == other.last_call_at
          return false unless @matched_name == other.matched_name
          return false unless @alternate_names == other.alternate_names
          return false unless @name_candidates == other.name_candidates
          return false unless @timezones == other.timezones
          return false unless @emails == other.emails
          return false unless @websites == other.websites
          return false unless @locations == other.locations
          return false unless @social_profiles == other.social_profiles
          return false unless @report_count == other.report_count
          return false unless @tag_count == other.tag_count
          return false unless @total_calls == other.total_calls
          return false unless @calls_60_days == other.calls_60_days
          return false unless @reports_60_days == other.reports_60_days
          return false unless @searches_60_days == other.searches_60_days
          return false unless @comment_count == other.comment_count
          return false unless @names_count == other.names_count
          return false unless @spam_report_count == other.spam_report_count
          true
        end
      end
    end
  end
end
