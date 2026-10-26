# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class FootprintCoherence
        extend T::Sig
        include Crystalline::MetadataFields

        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :birth_date,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("birth_date")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :gender,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("gender")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :nationality,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("nationality")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :country,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :city,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :zip,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("zip")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :name,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :company,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :website,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("website")}}
        )
        # How far independent sources agree on one attribute: values is the number of distinct values reported, support the tables and profiles reporting any, and agreement match (one value), partial (the most reported value holds more than half the support) or mismatch. The values themselves are not served.
        field(
          :social,
          Crystalline::Nilable.new(Models::Shared::AttributeAgreement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("social")}}
        )

        sig {
          params(
            birth_date: T.nilable(Models::Shared::AttributeAgreement),
            gender: T.nilable(Models::Shared::AttributeAgreement),
            nationality: T.nilable(Models::Shared::AttributeAgreement),
            country: T.nilable(Models::Shared::AttributeAgreement),
            city: T.nilable(Models::Shared::AttributeAgreement),
            zip: T.nilable(Models::Shared::AttributeAgreement),
            name: T.nilable(Models::Shared::AttributeAgreement),
            company: T.nilable(Models::Shared::AttributeAgreement),
            website: T.nilable(Models::Shared::AttributeAgreement),
            social: T.nilable(Models::Shared::AttributeAgreement)
          )
            .void
        }
        def initialize(
          birth_date: nil,
          gender: nil,
          nationality: nil,
          country: nil,
          city: nil,
          zip: nil,
          name: nil,
          company: nil,
          website: nil,
          social: nil
        )
          @birth_date = birth_date
          @gender = gender
          @nationality = nationality
          @country = country
          @city = city
          @zip = zip
          @name = name
          @company = company
          @website = website
          @social = social
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @birth_date == other.birth_date
          return false unless @gender == other.gender
          return false unless @nationality == other.nationality
          return false unless @country == other.country
          return false unless @city == other.city
          return false unless @zip == other.zip
          return false unless @name == other.name
          return false unless @company == other.company
          return false unless @website == other.website
          return false unless @social == other.social
          true
        end
      end
    end
  end
end
