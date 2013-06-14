require_relative "./test_helper"

class GettingMailTest < MiniTest::Unit::TestCase
  def test_connects_and_returns_messages
    gmail = Mail::GmailXoauth.new address: Config.email, access_token: access_token!

    gmail.all
  end
end
