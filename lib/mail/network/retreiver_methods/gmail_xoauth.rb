module Mail
  class GmailXoauth < IMAP
    class MissingAuthInfo < KeyError ; end

    def initialize(values)
      values.fetch(:address) { fail MissingAuthInfo }
      values.fetch(:access_token) { fail MissingAuthInfo }
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
