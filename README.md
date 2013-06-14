# Mail::Xoauth

Make the [Mail](https://github.com/mikel/mail) work with Gmail using
[OAuth](https://developers.google.com/gmail/oauth_overview). This
project is build on top of [gmail_xaouth](https://github.com/nfo/gmail_xoauth).
`Mail::Xoauth` simply makes provides a nice connect to mail's rich
delivery and retrevial interface.

## Installation

Add this line to your application's Gemfile:

    gem 'mail-xoauth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail-xoauth

## Usage

This gem **does not retreive oauth access or refresh tokesn for you!**
You must retrieve them yourself. `Mail::Xoauth` requires an access
token. It's up to you to ensure a valid access token using a refresh
token. If you do not know how to do that, then look at the tests.
There is an example class to handle this. Given a valid oauth access
token and email address you're ready to connect.

### Getting Email

```ruby
gmail = Mail::XOauthIMAP.new address: 'example@gmail.com', access_token: 'foo'

# Query using Mail's standard interface
gmail.all
```

### Sending Mail

```ruby
email = Mail.new do
  from 'example@gmail.com'
  to 'example@example.com'
  subject 'XOauth Test'
end

gmail = Mail::XOauthSMTP.new address: 'example@example.com', access_token: 'foo'
gmail.deliver! email
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
