# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One breach table that matched, detailed view only. name is the catalogue's display name for the table's site, not the upstream provider. No member carries a record, value, password or hash.
      class Breach
        extend T::Sig
        include Crystalline::MetadataFields

        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # Who is in the table: site_breach, a site's own users; credential_list, a combolist or compilation; stealer_log, malware or botnet victims; scrape; hacking_forum, a criminal hacking, cracking or carding community; abuse_service, the customers of DDoS-for-hire, account generators, dump or card shops, darknet markets, stalkerware or breach-lookup services; darkweb_site, an onion site of unknown purpose.
        field(
          :kind,
          Models::Shared::BreachKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::BreachKind, false)
            }
          }
        )
        # The submitted email or username whose own search matched the table. A submitted full name is searched as well, and what it finds feeds the identity's reasons rather than this list.
        field(
          :matched_on,
          Models::Shared::BreachSelector,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("matched_on"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::BreachSelector, false)
            }
          }
        )
        # The breached site's domain, lower case. Absent when the table has none (a credential list, for example).
        field(
          :domain,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("domain")}}
        )
        # The table's category from its name, lower case (social, gaming, combolist, ...).
        field(
          :category,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("category")}}
        )
        # A breach table's date year.
        field(
          :year,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("year")}}
        )
        # Absent when only the year is known.
        field(
          :month,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("month")}}
        )

        field(
          :exposed,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::BreachExposed)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("exposed")}}
        )
        # What this table's rows record against the matched email or username: the tables behind the forum_sanctioned and prior_payment_abuse reasons. Absent when the rows record none, for a table matched on an IP address, and from an answer stored before it was recorded.
        field(
          :conduct,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::BreachConduct)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("conduct")}}
        )

        sig {
          params(
            name: ::String,
            kind: Models::Shared::BreachKind,
            matched_on: Models::Shared::BreachSelector,
            domain: T.nilable(::String),
            category: T.nilable(::String),
            year: T.nilable(::Integer),
            month: T.nilable(::Integer),
            exposed: T.nilable(T::Array[Models::Shared::BreachExposed]),
            conduct: T.nilable(T::Array[Models::Shared::BreachConduct])
          )
            .void
        }
        def initialize(
          name:,
          kind:,
          matched_on:,
          domain: nil,
          category: nil,
          year: nil,
          month: nil,
          exposed: nil,
          conduct: nil
        )
          @name = name
          @kind = kind
          @matched_on = matched_on
          @domain = domain
          @category = category
          @year = year
          @month = month
          @exposed = exposed
          @conduct = conduct
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @kind == other.kind
          return false unless @matched_on == other.matched_on
          return false unless @domain == other.domain
          return false unless @category == other.category
          return false unless @year == other.year
          return false unless @month == other.month
          return false unless @exposed == other.exposed
          return false unless @conduct == other.conduct
          true
        end
      end
    end
  end
end
