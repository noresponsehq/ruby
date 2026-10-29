# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Download one authorized export chunk.
      class CustomerExportChunk
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :export_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("export_id"), required: true}}
        )

        field(
          :index,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("index"), required: true}}
        )

        field(
          :generation,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("generation"), required: true}}
        )

        field(
          :sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sha256"), required: true}}
        )
        # Base64-encoded UTF-8 JSON Lines, at most 256 KiB decoded. Each line is a typed customer export record. Decode and concatenate chunks in index order within the same generation.
        field :data, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("data"), required: true}}

        field(
          :next_chunk,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_chunk")}}
        )

        sig {
          params(
            export_id: ::String,
            index: ::Integer,
            generation: ::Integer,
            sha256: ::String,
            data: ::String,
            next_chunk: T.nilable(::Integer)
          )
            .void
        }
        def initialize(export_id:, index:, generation:, sha256:, data:, next_chunk: nil)
          @export_id = export_id
          @index = index
          @generation = generation
          @sha256 = sha256
          @data = data
          @next_chunk = next_chunk
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @export_id == other.export_id
          return false unless @index == other.index
          return false unless @generation == other.generation
          return false unless @sha256 == other.sha256
          return false unless @data == other.data
          return false unless @next_chunk == other.next_chunk
          true
        end
      end
    end
  end
end
