# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations
      autoload :CreateAssessmentRequest, "no_response/models/operations/createassessment_request.rb"
      autoload :CreateAssessmentResponse, "no_response/models/operations/createassessment_response.rb"
      autoload :CreateIntegrationResponse, "no_response/models/operations/createintegration_response.rb"
      autoload :CreateWebhookEndpointResponse, "no_response/models/operations/createwebhookendpoint_response.rb"
      autoload :DeleteIntegrationRequest, "no_response/models/operations/deleteintegration_request.rb"
      autoload :DeleteIntegrationResponse, "no_response/models/operations/deleteintegration_response.rb"
      autoload :DeleteWebhookEndpointRequest, "no_response/models/operations/deletewebhookendpoint_request.rb"
      autoload :DeleteWebhookEndpointResponse, "no_response/models/operations/deletewebhookendpoint_response.rb"
      autoload :GetAccountRequest, "no_response/models/operations/getaccount_request.rb"
      autoload :GetAccountResponse, "no_response/models/operations/getaccount_response.rb"
      autoload :GetAssessmentRequest, "no_response/models/operations/getassessment_request.rb"
      autoload :GetAssessmentResponse, "no_response/models/operations/getassessment_response.rb"
      autoload :ListAccountAssessmentsRequest, "no_response/models/operations/listaccountassessments_request.rb"
      autoload :ListAccountAssessmentsResponse, "no_response/models/operations/listaccountassessments_response.rb"
      autoload :ListIntegrationsResponse, "no_response/models/operations/listintegrations_response.rb"
      autoload :ListWebhookDeliveriesRequest, "no_response/models/operations/listwebhookdeliveries_request.rb"
      autoload :ListWebhookDeliveriesResponse, "no_response/models/operations/listwebhookdeliveries_response.rb"
      autoload :ListWebhookEndpointsResponse, "no_response/models/operations/listwebhookendpoints_response.rb"
      autoload :QueryAccountAssessmentsResponse, "no_response/models/operations/queryaccountassessments_response.rb"
      autoload :RecordAssessmentOutcomeRequest, "no_response/models/operations/recordassessmentoutcome_request.rb"
      autoload :RecordAssessmentOutcomeResponse, "no_response/models/operations/recordassessmentoutcome_response.rb"
      autoload :ReplayWebhookDeliveryRequest, "no_response/models/operations/replaywebhookdelivery_request.rb"
      autoload :ReplayWebhookDeliveryResponse, "no_response/models/operations/replaywebhookdelivery_response.rb"
      autoload :RotateApiKeyResponse, "no_response/models/operations/rotateapikey_response.rb"
      autoload :RotateIntegrationSecretRequest, "no_response/models/operations/rotateintegrationsecret_request.rb"
      autoload :RotateIntegrationSecretResponse, "no_response/models/operations/rotateintegrationsecret_response.rb"
      autoload :RotateWebhookSigningKeyRequest, "no_response/models/operations/rotatewebhooksigningkey_request.rb"
      autoload :RotateWebhookSigningKeyResponse, "no_response/models/operations/rotatewebhooksigningkey_response.rb"
      autoload :SendWebhookTestEventRequest, "no_response/models/operations/sendwebhooktestevent_request.rb"
      autoload :SendWebhookTestEventResponse, "no_response/models/operations/sendwebhooktestevent_response.rb"
    end
  end
end
