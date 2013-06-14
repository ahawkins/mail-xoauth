module Mail
  class XOauthIMAP < IMAP
    class MissingAuthInfo < KeyError ; end

    def initialize(values)
      fail MissingAuthInfo unless values[:address]
      fail MissingAuthInfo unless values[:access_token]
      super values
    end

    def start(config=Mail::Configuration.instance, &block)
      raise ArgumentError.new("Mail::Retrievable#imap_start takes a block") unless block_given?

      imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
      imap.authenticate 'XOAUTH2', settings.fetch(:address), settings.fetch(:access_token)

      yield imap
    ensure
      if defined?(imap) && imap && !imap.disconnected?
        imap.disconnect
      end
    end
  end
end
