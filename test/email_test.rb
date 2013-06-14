require_relative "./test_helper"

class GettingMailTest < MiniTest::Unit::TestCase
  def test_connects_and_returns_messages
    gmail = Mail::XOauthIMAP.new address: Config.email, access_token: access_token!
    gmail.all
  end

  def test_round_trips_email
    email = Mail.new do
      from Config.email
      to Config.email
      subject 'XOauth Test'
    end

    gmail = Mail::XOauthSMTP.new address: Config.email, access_token: access_token!

    gmail.deliver! email
  end

  def test_raises_an_error_when_missing_the_address_for_imap
    assert_raises Mail::XOauthIMAP::MissingAuthInfo do
      Mail::XOauthIMAP.new address: nil, access_token: 'foo'
    end

    assert_raises Mail::XOauthIMAP::MissingAuthInfo do
      Mail::XOauthIMAP.new  access_token: 'foo'
    end
  end

  def test_raises_an_error_when_missing_the_access_token_for_imap
    assert_raises Mail::XOauthIMAP::MissingAuthInfo do
      Mail::XOauthIMAP.new address: 'foo', access_token: nil
    end

    assert_raises Mail::XOauthIMAP::MissingAuthInfo do
      Mail::XOauthIMAP.new address: 'foo'
    end
  end

  def test_raises_an_error_when_missing_the_address_for_smtp
    assert_raises Mail::XOauthSMTP::MissingAuthInfo do
      Mail::XOauthSMTP.new address: nil, access_token: 'foo'
    end

    assert_raises Mail::XOauthSMTP::MissingAuthInfo do
      Mail::XOauthSMTP.new  access_token: 'foo'
    end
  end

  def test_raises_an_error_when_missing_the_access_token_for_smtp
    assert_raises Mail::XOauthSMTP::MissingAuthInfo do
      Mail::XOauthSMTP.new address: 'foo', access_token: nil
    end

    assert_raises Mail::XOauthSMTP::MissingAuthInfo do
      Mail::XOauthSMTP.new address: 'foo'
    end
  end
end
