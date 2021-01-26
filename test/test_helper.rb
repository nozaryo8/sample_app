ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # 特定のワーカーではテストをパラレル実行する
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # すべてのテストがアルファベット順に実行されるよう、
  #test/fixtures/*.ymlにあるすべてのfixtureをセットアップする
  fixtures :all

  #test環境でもApplicationヘルパーを使えるようにする
  include ApplicationHelper
  # Add more helper methods to be used by all tests here...
  
  # テストユーザーがログイン中の場合にtrueを返す 8.30
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # テストユーザーとしてログインする9.24
  def log_in_as(user)
    session[:user_id] = user.id
  end
  
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
  
end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする 9.24
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
