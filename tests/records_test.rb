# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'faraday'
require 'noresponse'

# A person's report returns the contract's worked records as typed models.
class RecordsTest < Minitest::Test
  def test_a_persons_report_returns_typed_records
    models = NoResponse::Models::Shared
    body = File.read(File.join(__dir__, 'fixtures', 'valid', 'person-report-records.json'))
    person = JSON.parse(body)['person']
    workspace = 'tnt_01JC8Y0A2B4C6D8E0F2G4H6J8K'
    path = "/v1/workspaces/#{workspace}/groups/test/#{person['group_id']}/people/#{person['id']}"
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(path) { [200, { 'Content-Type' => 'application/json' }, body] }
    end
    client = NoResponse::NoResponseClient.new(client: Faraday.new { |f| f.adapter(:test, stubs) }, api_key: 'nrk_test_records_fixture', server_url: 'https://api.example.test')
    report = client.groups.get_person(workspace_id: workspace, environment: models::KeyEnvironment::TEST, group_id: person['group_id'], person_id: person['id']).result
    stubs.verify_stubbed_calls

    account, row = report.lookup.records
    assert_instance_of models::Record, account
    assert_equal 'platform', account.source.kind
    assert_equal 'github.com', account.source.site
    field = ->(record, name) { record.fields_.find { |each| each.field == name } }
    login = field.call(account, 'login')
    assert_equal models::RecordKind::USERNAME, login.kind
    assert_equal models::RecordRole::HANDLE, login.role
    assert_equal 'jordan-ellis', login.value
    assert_equal models::Rating::DISTINCTIVE, login.distinctive.rating
    assert_equal 'Jordan Ellis', field.call(account, 'name').value
    assert_nil field.call(account, 'hireable').role
    assert_in_delta 0.74, account.likelihood
    assert_equal %w[name twitter_username], account.agreed
    assert account.joined
    assert_equal models::Verdict::JOINED, account.verdict

    assert_equal 'site_breach', row.source.kind
    assert_equal 'FORUM_EXAMPLE_NET_2019', row.source.table
    assert_equal '2019-03', row.source.date
    password = field.call(row, 'password')
    assert_equal models::RecordKind::PASSWORD, password.kind
    assert_equal 'Leeds1990!', password.value
    assert_equal 'bcrypt', field.call(row, 'password_hash').detail
    last_ip = field.call(row, 'lastip')
    assert_equal models::RecordRole::LAST_IP, last_ip.role
    assert_equal '203.0.113.5', last_ip.value
    birthday = field.call(row, 'birthday')
    assert_nil birthday.value
    assert_equal '07/03/1990', birthday.original
    assert_in_delta 0.99, row.likelihood
    assert_nil row.verdict

    remaining = report.lookup.remaining[0]
    assert_equal 'credential_list', remaining.source.kind
    assert_equal 'username', remaining.by
    assert_equal 37, remaining.rows
  end
end
