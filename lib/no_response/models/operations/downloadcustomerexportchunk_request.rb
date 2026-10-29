# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DownloadCustomerExportChunkRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )

        field :export_id, ::String, {'path_param': {'field_name': "export_id", 'style': "simple", 'explode': false}}

        field(
          :chunk_index,
          ::Integer,
          {'path_param': {'field_name': "chunk_index", 'style': "simple", 'explode': false}}
        )

        sig { params(workspace_id: ::String, export_id: ::String, chunk_index: ::Integer).void }
        def initialize(workspace_id:, export_id:, chunk_index:)
          @workspace_id = workspace_id
          @export_id = export_id
          @chunk_index = chunk_index
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @export_id == other.export_id
          return false unless @chunk_index == other.chunk_index
          true
        end
      end
    end
  end
end
