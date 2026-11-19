# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One answer from one source: where it came from, what found it and every field it holds. A person's lookup records also say how likely each is the person.
      class Record
        extend T::Sig
        include Crystalline::MetadataFields

        # Made from the source and the fields' names and original values, so the same answer found twice is one record with the same id. Its fields are typed as its latest finding typed them.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Where a record came from.
        field(
          :source,
          Models::Shared::RecordSource,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("source"), required: true}}
        )
        # Each kind of searched value that found the record.
        field(
          :matched,
          Crystalline::Array.new(Models::Shared::RecordMatch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched"), required: true}}
        )
        # Every field the source returned, in the order the source's connector lists them; a breach row's columns in name order. Nothing is withheld: a breach row's passwords, hashes and salts are fields like any other.
        field(
          :fields_,
          Crystalline::Array.new(Models::Shared::RecordField),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("fields"), required: true}}
        )
        # When the source last gave this answer.
        field(
          :observed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at"), required: true}}
        )
        # How likely the record is the person it was found for, from 0.01 to 0.99, to two places. A record found by the person's own email or phone starts as theirs, and one found by a search of a value another record holds starts at that record's likelihood divided by one plus the records its search found on its site; any other starts lower the more people its search found on its site, or anywhere for a name search. Each value it shares with what is known of the person raises it, a rare value more than a common one, and a different birth date or full name lowers it. What is known is what the person's row gives and the values of their joined records: those found by their email or phone, those a reviewer joined and those whose likelihood reaches 0.9. Each record that joins adds its values and the rest are scored again until the joined records stop changing; a record whose likelihood falls below 0.9 is not joined and adds nothing, so a reviewer's rejection also undoes the joins that came through the rejected record. A record whose source kind starts with domain_ describes an email's domain, not the person, so it is not compared and adds nothing to what is known: it stays at 0.99 when the person's own email found it and at 0.5 otherwise. Present on a person's lookup records, with agreed, clashed and joined.
        field(
          :likelihood,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("likelihood")}}
        )
        # The fields of this record whose values agreed with what is known of the person, by their field names, in the record's order. The value that found the record is not among them.
        field(
          :agreed,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("agreed")}}
        )
        # The fields of this record that clashed with what is known of the person: a birth date or a full name that differs from the person's.
        field(
          :clashed,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("clashed")}}
        )
        # Whether the record joins the person: its likelihood reached 0.9 or a reviewer joined it, and no reviewer rejected it. A record that does not join stays a lead.
        field(
          :joined,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("joined")}}
        )
        # A reviewer's overrule (POST .../people/{person_id}/records), which decides joined whatever the likelihood and sticks for as long as a lookup finds the same record. Absent when nobody overruled it.
        field(
          :verdict,
          Crystalline::Nilable.new(Models::Shared::Verdict),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("verdict"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Verdict, true)
            }
          }
        )
        # Why the record has its likelihood, as the items that make it up: what found it and each value it agrees or clashes with, each with its weight in bits. The bits add up to the likelihood before rounding: likelihood = 1 / (1 + 2^-sum). Only the strongest agreement of each kind counts, and a place counts once however many of its city, region, country and address agree. Present on a person's lookup records that have any such item.
        field(
          :evidence,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::RecordEvidence)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence")}}
        )
        # How the record connects to what the investigator gave: given first, then the ids of the joined records it reached the person through, nearest last. Each step follows what found the record before the strongest agreement. A record with no link to the person has no path.
        field(
          :path,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("path")}}
        )
        # For a record that is not the person's, the other person it belongs with: records that share this number share strong values, such as an email or a full name with a phone, and score as one person against each other. Absent on the person's own records and on a record that matches nobody else. A value that more than 20 strangers hold groups nobody.
        field(
          :other_person,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("other_person")}}
        )

        sig {
          params(
            id: ::String,
            source: Models::Shared::RecordSource,
            matched: T::Array[Models::Shared::RecordMatch],
            fields_: T::Array[Models::Shared::RecordField],
            observed_at: ::String,
            likelihood: T.nilable(::Float),
            agreed: T.nilable(T::Array[::String]),
            clashed: T.nilable(T::Array[::String]),
            joined: T.nilable(T::Boolean),
            verdict: T.nilable(Models::Shared::Verdict),
            evidence: T.nilable(T::Array[Models::Shared::RecordEvidence]),
            path: T.nilable(T::Array[::String]),
            other_person: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          id:,
          source:,
          matched:,
          fields_:,
          observed_at:,
          likelihood: nil,
          agreed: nil,
          clashed: nil,
          joined: nil,
          verdict: nil,
          evidence: nil,
          path: nil,
          other_person: nil
        )
          @id = id
          @source = source
          @matched = matched
          @fields_ = fields_
          @observed_at = observed_at
          @likelihood = likelihood
          @agreed = agreed
          @clashed = clashed
          @joined = joined
          @verdict = verdict
          @evidence = evidence
          @path = path
          @other_person = other_person
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @source == other.source
          return false unless @matched == other.matched
          return false unless @fields_ == other.fields_
          return false unless @observed_at == other.observed_at
          return false unless @likelihood == other.likelihood
          return false unless @agreed == other.agreed
          return false unless @clashed == other.clashed
          return false unless @joined == other.joined
          return false unless @verdict == other.verdict
          return false unless @evidence == other.evidence
          return false unless @path == other.path
          return false unless @other_person == other.other_person
          true
        end
      end
    end
  end
end
