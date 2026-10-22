# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'noresponse'

class IssuedCredentialTest < Minitest::Test
  CASES = JSON.parse(File.read(File.join(__dir__, 'fixtures', 'issued-credential-vectors.json')))['cases']

  def test_vectors
    refute_empty CASES
    CASES.each do |c|
      assert_equal c['sha256'], NoResponse::IssuedCredential.sha256(c['key']), c['key']
    end
  end

  def test_empty_key_is_refused
    assert_raises(ArgumentError) { NoResponse::IssuedCredential.sha256('') }
  end
end
