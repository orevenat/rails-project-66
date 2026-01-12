# frozen_string_literal: true

require "test_helper"

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    user = users(:one)
    sign_in(user)

    check = repository_checks(:rails_check_1)
    get repository_check_path(check.repository, check)
    assert_response :success
  end

  test "#create" do
    user = users(:one)
    sign_in(user)

    repository = repositories(:rails_rails)

    post repository_checks_path(repository)
    assert_response :redirect
  end
end
