# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Errors
      autoload :APIStatusError, "no_response/models/errors/apistatuserror.rb"
      autoload :AuthenticationError, "no_response/models/errors/authenticationerror.rb"
      autoload :BadRequestError, "no_response/models/errors/badrequesterror.rb"
      autoload :ConflictError, "no_response/models/errors/conflicterror.rb"
      autoload :NotFoundError, "no_response/models/errors/notfounderror.rb"
      autoload :PermissionDeniedError, "no_response/models/errors/permissiondeniederror.rb"
      autoload :RateLimitError, "no_response/models/errors/ratelimiterror.rb"
    end
  end
end
