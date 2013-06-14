module Mail
  class XOauthSMTP < SMTP
    class MissingAuthInfo < KeyError ; end

    def initialize(values)
      fail MissingAuthInfo unless values[:address]
      fail MissingAuthInfo unless values[:access_token]
      super values
    end

    def deliver!(mail)
      smtp_from, smtp_to, message = check_delivery_params(mail)

      smtp = Net::SMTP.new('smtp.gmail.com', 587)
      smtp.enable_starttls_auto
      smtp.start('gmail.com', settings.fetch(:address), settings.fetch(:access_token), :xoauth2) do |connection|
        response = connection.sendmail(message, smtp_from, smtp_to)
      end

      if settings[:return_response]
        response
      else
        self
      end
    end
  end
end
