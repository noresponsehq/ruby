# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class IdentifierExpressionLeaf
        extend T::Sig
        include Crystalline::MetadataFields

        # One customer-submitted identifier. Defaults to exact comparison of the original submitted value. canonical uses the supported identifier normalisation without an ownership claim: email preserves local-part case, NFC-normalises it and lowercases the domain without removing dots or tags; phone uses international E.164 without extensions or an inferred region; username uses NFC and Unicode case folding within the customer namespace. mailbox is email-only and explicitly selects existing list rules: case-insensitive, remove +tag, and ignore local-part dots at gmail.com and googlemail.com; googlemail.com maps to gmail.com. Username requires namespace customer. Email and phone forbid namespace. Source-discovered identifiers and platform handles are not searched. Unsupported kinds, namespaces, modes and invalid values return 400. Search equality does not establish verified ownership or merge accounts.
        field(
          :term,
          Models::Shared::IdentifierSearch,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("term"), required: true}}
        )

        sig { params(term: Models::Shared::IdentifierSearch).void }
        def initialize(term:)
          @term = term
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @term == other.term
          true
        end
      end
    end
  end
end
