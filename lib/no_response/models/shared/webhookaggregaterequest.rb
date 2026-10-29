# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Count every retained matching attempt in [from,to). Capture is best effort; missing attempts cannot be inferred. UTC buckets may be partial at the edges. The window is at most 30 days.
      class WebhookAggregateRequest
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
        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id")}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            bucket: T.nilable(Models::Shared::RequestAggregateRequestBucket),
            status: T.nilable(::Integer),
            endpoint_id: T.nilable(::String)
          )
            .void
        }
        def initialize(from:, to:, bucket: nil, status: nil, endpoint_id: nil)
          @from = from
          @to = to
          @bucket = bucket
          @status = status
          @endpoint_id = endpoint_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @bucket == other.bucket
          return false unless @status == other.status
          return false unless @endpoint_id == other.endpoint_id
          true
        end
      end
    end
  end
end
