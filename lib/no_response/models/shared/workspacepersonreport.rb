# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read a workspace person.
      class WorkspacePersonReport
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # The time the workspace retention policy removes this person, their evidence and investigation history. Shortening workspace retention can move this time earlier.
        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )
        # Every group this person belongs to in this environment, most recently added first, with their role in each. A person can belong to any number of groups; removing them from a group or deleting the group removes it here.
        field(
          :groups,
          Crystalline::Array.new(Models::Shared::PersonGroup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("groups"), required: true}}
        )
        # The accounts this result matched, with how each was matched.
        field(
          :profiles,
          Crystalline::Array.new(Models::Shared::ScreeningProfile),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("profiles"), required: true}}
        )
        # What this result flagged, most severe first, each citing its evidence.
        field(
          :findings,
          Crystalline::Array.new(Models::Shared::ScreeningFinding),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("findings"), required: true}}
        )
        # All posts retained for this result, including posts that no finding cites.
        field(
          :posts,
          Crystalline::Array.new(Models::Shared::ScreeningPost),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("posts"), required: true}}
        )
        # All images and videos retained for this result, including media that no finding cites.
        field(
          :media,
          Crystalline::Array.new(Models::Shared::ScreeningMedia),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("media"), required: true}}
        )
        # The searches enrichment would start on this person, likeliest record first, under the environment's enrichment setting for a person's own investigation. In off mode the list is empty. In suggest mode enrichment starts none of them by itself; in automatic mode it starts them as its limits allow. Empty when evidence.read is denied.
        field(
          :suggested_searches,
          Crystalline::Array.new(Models::Shared::SuggestedSearch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("suggested_searches"), required: true}}
        )
        # What changed between each settled investigation of this person and the one before it, unreviewed first, then most significant, then newest. The first investigation records no changes. When evidence.read is denied, before and after are withheld.
        field(
          :changes,
          Crystalline::Array.new(Models::Shared::PersonChange),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("changes"), required: true}}
        )
        # The person's rerun schedule. Each due run starts a full investigation of the person, as POST /v1/investigations with no platforms does, and its changes are stored as changes. The schedule lives in the database and the worker runs it, so it survives restarts and releases; each due run starts exactly one investigation.
        field(
          :schedule,
          Models::Shared::PersonSchedule,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schedule"), required: true}}
        )
        # Your reference for this person within the workspace environment. Only an explicit reference or person_id can reuse an existing person.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )

        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # The person's email.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The person's phone in E.164 form.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # Where the person works.
        field(
          :company,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # Where the person lives.
        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # A username the person uses, with no platform. A search looks it up on every platform that finds accounts by username.
        field(
          :username,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )
        # Accounts the person is known to hold, at most 20.
        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )
        # What the signup check's lookups found for a person: account presence for the email, phone and usernames (the person's handles), the phone lookup, the email domain's registration and the breach search. Context and coverage for the reviewer, not a finding: nothing here sets a band or a match state.
        field(
          :lookup,
          Crystalline::Nilable.new(Models::Shared::ScreeningLookup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("lookup")}}
        )
        # Every search on this person's values, newest first, whether a person started it or enrichment did: each names the value, the record and field it came from, and the search that found that record. Absent when nothing was searched.
        field(
          :searches,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Search)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("searches")}}
        )
        # True when evidence.read is explicitly denied. Submitted details, coverage, job status and decisions remain available. Collected records, profiles, findings, posts, media, discovered values and free-text decision notes are withheld.
        field(
          :evidence_restricted,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence_restricted")}}
        )
        # The most recent retained completed or partial investigation, or a migrated result whose original per-person status is unknown. The evidence below belongs to this investigation. Read investigation history for earlier results and pending jobs.
        field(
          :evidence_investigation,
          Crystalline::Nilable.new(Models::Shared::Investigation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence_investigation"), required: true}}
        )
        # An investigator's profile of this person, written from the evidence of a settled investigation. Null until an investigation completes or partially completes, and null when evidence.read is denied.
        field(
          :written_profile,
          Crystalline::Nilable.new(Models::Shared::WrittenProfile),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("written_profile"), required: true}}
        )

        sig {
          params(
            id: ::String,
            created_at: ::String,
            updated_at: ::String,
            expires_at: ::String,
            groups: T::Array[Models::Shared::PersonGroup],
            profiles: T::Array[Models::Shared::ScreeningProfile],
            findings: T::Array[Models::Shared::ScreeningFinding],
            posts: T::Array[Models::Shared::ScreeningPost],
            media: T::Array[Models::Shared::ScreeningMedia],
            suggested_searches: T::Array[Models::Shared::SuggestedSearch],
            changes: T::Array[Models::Shared::PersonChange],
            schedule: Models::Shared::PersonSchedule,
            external_id: T.nilable(::String),
            name: T.nilable(::String),
            email: T.nilable(::String),
            phone: T.nilable(::String),
            company: T.nilable(::String),
            city: T.nilable(::String),
            username: T.nilable(::String),
            handles: T.nilable(T::Array[Models::Shared::Handle]),
            lookup: T.nilable(Models::Shared::ScreeningLookup),
            searches: T.nilable(T::Array[Models::Shared::Search]),
            evidence_restricted: T.nilable(T::Boolean),
            evidence_investigation: T.nilable(Models::Shared::Investigation),
            written_profile: T.nilable(Models::Shared::WrittenProfile)
          )
            .void
        }
        def initialize(
          id:,
          created_at:,
          updated_at:,
          expires_at:,
          groups:,
          profiles:,
          findings:,
          posts:,
          media:,
          suggested_searches:,
          changes:,
          schedule:,
          external_id: nil,
          name: nil,
          email: nil,
          phone: nil,
          company: nil,
          city: nil,
          username: nil,
          handles: nil,
          lookup: nil,
          searches: nil,
          evidence_restricted: nil,
          evidence_investigation: nil,
          written_profile: nil
        )
          @id = id
          @created_at = created_at
          @updated_at = updated_at
          @expires_at = expires_at
          @groups = groups
          @profiles = profiles
          @findings = findings
          @posts = posts
          @media = media
          @suggested_searches = suggested_searches
          @changes = changes
          @schedule = schedule
          @external_id = external_id
          @name = name
          @email = email
          @phone = phone
          @company = company
          @city = city
          @username = username
          @handles = handles
          @lookup = lookup
          @searches = searches
          @evidence_restricted = evidence_restricted
          @evidence_investigation = evidence_investigation
          @written_profile = written_profile
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @expires_at == other.expires_at
          return false unless @groups == other.groups
          return false unless @profiles == other.profiles
          return false unless @findings == other.findings
          return false unless @posts == other.posts
          return false unless @media == other.media
          return false unless @suggested_searches == other.suggested_searches
          return false unless @changes == other.changes
          return false unless @schedule == other.schedule
          return false unless @external_id == other.external_id
          return false unless @name == other.name
          return false unless @email == other.email
          return false unless @phone == other.phone
          return false unless @company == other.company
          return false unless @city == other.city
          return false unless @username == other.username
          return false unless @handles == other.handles
          return false unless @lookup == other.lookup
          return false unless @searches == other.searches
          return false unless @evidence_restricted == other.evidence_restricted
          return false unless @evidence_investigation == other.evidence_investigation
          return false unless @written_profile == other.written_profile
          true
        end
      end
    end
  end
end
