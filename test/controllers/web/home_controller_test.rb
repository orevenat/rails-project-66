# frozen_string_literal: true

require 'test_helper'

module Web
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test 'index' do
      get root_path
      assert_response :success
    end

    test '#index with auth' do
      user = users(:one)
      sign_in(user)

      assert signed_in?

      get root_path
      assert_response :success
    end
  end
end
