# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'noresponse'

class AuthTest < Minitest::Test
  FIXTURES = File.join(__dir__, 'fixtures')
  VECTORS = JSON.parse(File.read(File.join(FIXTURES, 'auth-context-vectors.json')))['cases']

  def run_vector(vector)
    claims = vector['claims']
    overrides = vector['overrides']
    case vector['provider']
    when 'workos' then NoResponse::Auth.from_workos(claims, overrides)
    when 'clerk' then NoResponse::Auth.from_clerk(claims, overrides)
    when 'auth0' then NoResponse::Auth.from_auth0(claims, overrides)
    when 'supabase' then NoResponse::Auth.from_supabase(claims, overrides)
    when 'firebase' then NoResponse::Auth.from_firebase(claims, overrides)
    when 'cognito' then NoResponse::Auth.from_cognito(claims, overrides)
    when 'entra' then NoResponse::Auth.from_entra(claims, overrides)
    when 'keycloak' then NoResponse::Auth.from_keycloak(claims, overrides)
    when 'ory' then NoResponse::Auth.from_ory(claims, overrides)
    when 'ory_oauth2' then NoResponse::Auth.from_ory_oauth2(claims, overrides)
    else NoResponse::Auth.from_oidc(vector['provider'], claims, overrides)
    end
  end

  def compact(value)
    case value
    when Hash then value.reject { |_, v| v.nil? }.transform_values { |v| compact(v) }
    when Array then value.map { |v| compact(v) }
    else value
    end
  end

  def test_shared_vectors
    refute_empty VECTORS
    VECTORS.each do |vector|
      if vector['error']
        assert_raises(ArgumentError, vector['name']) { run_vector(vector) }
      else
        got = compact(JSON.parse(Crystalline.to_json(run_vector(vector))))
        assert_equal vector['expect'], got, vector['name']
      end
    end
  end

  def test_embedded_claim_map_is_the_contract_map
    table = JSON.parse(File.read(File.join(FIXTURES, 'auth-context-claim-map.json')))
    table.delete('description')
    table.delete('rules')
    table['providers'].each_value { |provider| provider.delete('notes') }
    assert_equal table, NoResponse::Auth::CLAIM_MAP
  end
end
