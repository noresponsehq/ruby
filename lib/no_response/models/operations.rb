# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations
      autoload :CreateAssessmentRequest, "no_response/models/operations/createassessment_request.rb"
      autoload :CreateAssessmentResponse, "no_response/models/operations/createassessment_response.rb"
      autoload :GetAssessmentRequest, "no_response/models/operations/getassessment_request.rb"
      autoload :GetAssessmentResponse, "no_response/models/operations/getassessment_response.rb"
      autoload :QueryAccountAssessmentsResponse, "no_response/models/operations/queryaccountassessments_response.rb"
      autoload :RecordAssessmentOutcomeRequest, "no_response/models/operations/recordassessmentoutcome_request.rb"
      autoload :RecordAssessmentOutcomeResponse, "no_response/models/operations/recordassessmentoutcome_response.rb"
      autoload :RotateApiKeyResponse, "no_response/models/operations/rotateapikey_response.rb"
    end
  end
end
