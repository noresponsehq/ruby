# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Count every retained matching attempt in [from,to). Capture is best effort; missing attempts cannot be inferred. UTC buckets may be partial at the edges. The window is at most 7 days.
      class RequestAggregateRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}

        field(
          :bucket,
          Crystalline::Nilable.new(Models::Shared::RequestAggregateRequestBucket),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("bucket"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RequestAggregateRequestBucket, true)
            }
          }
        )

        field(
          :status,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("status")}}
        )

        field(
          :route,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("route")}}
        )

        field(
          :api_key_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("api_key_id")}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            bucket: T.nilable(Models::Shared::RequestAggregateRequestBucket),
            status: T.nilable(::Integer),
            route: T.nilable(::String),
            api_key_id: T.nilable(::String)
          )
            .void
        }
        def initialize(from:, to:, bucket: nil, status: nil, route: nil, api_key_id: nil)
          @from = from
          @to = to
          @bucket = bucket
          @status = status
          @route = route
          @api_key_id = api_key_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @bucket == other.bucket
          return false unless @status == other.status
          return false unless @route == other.route
          return false unless @api_key_id == other.api_key_id
          true
        end
      end
    end
  end
end
