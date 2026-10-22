# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations
      autoload :CreateAssessmentRequest, "no_response/models/operations/createassessment_request.rb"
      autoload :CreateAssessmentResponse, "no_response/models/operations/createassessment_response.rb"
      autoload :CreateIntegrationResponse, "no_response/models/operations/createintegration_response.rb"
      autoload :DeleteIntegrationRequest, "no_response/models/operations/deleteintegration_request.rb"
      autoload :DeleteIntegrationResponse, "no_response/models/operations/deleteintegration_response.rb"
      autoload :GetAssessmentRequest, "no_response/models/operations/getassessment_request.rb"
      autoload :GetAssessmentResponse, "no_response/models/operations/getassessment_response.rb"
      autoload :ListIntegrationsResponse, "no_response/models/operations/listintegrations_response.rb"
      autoload :QueryAccountAssessmentsResponse, "no_response/models/operations/queryaccountassessments_response.rb"
      autoload :RecordAssessmentOutcomeRequest, "no_response/models/operations/recordassessmentoutcome_request.rb"
      autoload :RecordAssessmentOutcomeResponse, "no_response/models/operations/recordassessmentoutcome_response.rb"
      autoload :RotateApiKeyResponse, "no_response/models/operations/rotateapikey_response.rb"
      autoload :RotateIntegrationSecretRequest, "no_response/models/operations/rotateintegrationsecret_request.rb"
      autoload :RotateIntegrationSecretResponse, "no_response/models/operations/rotateintegrationsecret_response.rb"
    end
  end
end
