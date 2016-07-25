require 'rest_client'


module Mailgun
  class Client
    attr_reader :api_key
    attr_accessor :domain

    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    def send_message(options, settings = {})
      custom_api_key = (!settings.nil? && settings.has_key?(:api_key)) ? settings[:api_key] : nil
      custom_domain = (!settings.nil? && settings.has_key?(:domain)) ? settings[:domain] : nil

      RestClient.post mailgun_url(custom_api_key, custom_domain), options
    end

    def mailgun_url(custom_api_key = nil, custom_domain = nil)
      api_url(custom_api_key, custom_domain) + "/messages"
    end

    def api_url(custom_api_key = nil, custom_domain = nil)
      custom_api_key ||= api_key
      custom_domain ||= domain
      "https://api:#{custom_api_key}@api.mailgun.net/v3/#{custom_domain}"
    end
  end
end
