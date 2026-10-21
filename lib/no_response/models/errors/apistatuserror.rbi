# typed: true
# frozen_string_literal: true

class NoResponse::Models::Errors::NoResponseError < StandardError
end

class NoResponse::Models::Errors::APIStatusError < NoResponse::Models::Errors::NoResponseError
  extend ::Crystalline::MetadataFields::ClassMethods
end

class NoResponse::Models::Errors::APIStatusError

  def body
  end

  def body=(body)
  end

  def raw_response
  end

  def raw_response=(raw_response)
  end

  def status_code
  end

  def status_code=(status_code)
  end
end
