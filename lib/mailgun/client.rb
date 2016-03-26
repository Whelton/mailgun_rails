require 'rest_client'


module Mailgun
  class Client
    attr_reader :api_key, :domain

    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    def send_message(options)
      post_message(messages_url, options)
    end

    def send_mime_message(options)
      post_message(mime_messages_url, options.merge({multipart: true}))
    end

    private

    def post_message(url, options)
      RestClient.post url, options
    rescue RestClient::Exception => e
      raise DeliveryFailedError, "#{e.message} - #{e.http_body}"
    end

    def messages_url
      api_url + "/messages"
    end

    def mime_messages_url
      api_url + "/messages.mime"
    end

    def api_url
      "https://api:#{api_key}@api.mailgun.net/v3/#{domain}"
    end

    class DeliveryFailedError < StandardError; end
  end
end
