# frozen_string_literal: true

require "test_helper"

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    repository = repositories(:carrierwave_upload)

    payload = {
      repository: {
        id: repository.github_id,
        full_name: repository.full_name
      }
    }

    post api_checks_url, params: payload, as: :json
    assert_response :ok

    check = repository.checks.last

    assert { check }
    assert { check.finished? }
    assert { check.passed }
  end
end
