# frozen_string_literal: true

require 'faraday'

module BeyondApi
  class Connection
    def self.default
      Faraday.new(ssl: { verify: true }) do |faraday|
        faraday.options[:open_timeout] = BeyondApi.configuration.open_timeout.to_i
        faraday.options[:timeout] = BeyondApi.configuration.timeout.to_i
        faraday.headers['Accept'] = 'application/json'
        faraday.headers['Content-Type'] = 'application/json'
        faraday.request(:multipart)
        faraday.request(:url_encoded)
        faraday.adapter(:net_http)
      end
    end

    def self.token
      Faraday.new(ssl: { verify: true }) do |faraday|
        faraday.options[:open_timeout] = BeyondApi.configuration.open_timeout.to_i
        faraday.options[:timeout] = BeyondApi.configuration.timeout.to_i
        faraday.headers['Accept'] = 'application/json'
        faraday.adapter(:net_http)
        faraday.basic_auth(BeyondApi.configuration.client_id,
                           BeyondApi.configuration.client_secret)
      end
    end

    def self.multipart
      Faraday.new(ssl: { verify: true }, request: { params_encoder: Faraday::FlatParamsEncoder }) do |faraday|
        faraday.options[:open_timeout] = BeyondApi.configuration.open_timeout.to_i
        faraday.options[:timeout] = BeyondApi.configuration.timeout.to_i
        faraday.request :multipart
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
