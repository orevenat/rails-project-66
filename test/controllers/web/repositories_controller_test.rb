require "test_helper"

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "#index" do
    user = users(:one)
    sign_in(user)

    assert signed_in?

    get repositories_path
    assert_response :success
  end

  test "#show" do
    user = users(:one)
    sign_in(user)
    repository = repositories(:rails_rails)

    get repository_path(repository)
    assert_response :success
  end

  test "#new" do
    user = users(:one)
    sign_in(user)

    get new_repository_path
    assert_response :success
  end

  test "#create" do
    user = users(:one)
    sign_in(user)

    id = Faker::Number.number(digits: 3)
    attrs = {
      repository: {
        github_id: id
      }
    }

    post repositories_path, params: attrs
    assert_response :redirect

    repository = Repository.find_by(github_id: id)

    assert { repository }
    assert { repository.language.present? }
    assert { repository.full_name.present? }
  end
end
