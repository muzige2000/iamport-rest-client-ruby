require "iamport/version"

module Iamport
  IAMPORT_HOST = "https://api.iamport.kr"

  class Config
    attr_accessor :api_key
    attr_accessor :api_secret
  end

  class << self
    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= Config.new
    end

    # Get Token
    # https://api.iamport.kr/#!/authenticate/getToken
    def token
      url = "#{IAMPORT_HOST}/users/getToken"
      body = {
          imp_key: config.api_key,
          imp_secret: config.api_secret
      }

      result = HTTParty.post url, body: body
      result["response"]["access_token"]
    end

    # Get payment information using imp_uid
    # https://api.iamport.kr/#!/payments/getPaymentByImpUid
    def payment(imp_uid)
      uri = "payments/#{imp_uid}"

      pay_get(uri)
    end

    # Search payment information using status.
    # default items per page: 20
    # https://api.iamport.kr/#!/payments/getPaymentsByStatus
    def payments(options = {})
      status = options[:status] || "all"
      page = options[:page] || 1

      uri = "payments/status/#{status}?page=#{page}"

      pay_get(uri)
    end

    # Find payment information using merchant uid
    # https://api.iamport.kr/#!/payments/getPaymentByMerchantUid
    def find(merchant_uid)
      uri = "payments/find/#{merchant_uid}"

      pay_get(uri)
    end

    # Canceled payments
    # https://api.iamport.kr/#!/payments/cancelPayment
    def cancel(body)
      uri = "payments/cancel"

      pay_post(uri, body)
    end


    # Subscribe payment onetime
    # https://api.iamport.kr/#!/subscribe/payments/onetime
    def subscribe_onetime(body)
      pay_post("subscribe/payments/onetime", body)
    end

    # Subscribe payment again
    # https://api.iamport.kr/#!/subscribe/payments/again
    def subscribe_again(body)
      pay_post("subscribe/payments/again", body)
    end

    # Subscribe payment schedule
    # https://api.iamport.kr/#!/subscribe/payments/again
    def subscribe_schedule(body)
      pay_post("subscribe/payments/again", body)
    end

    # Subscribe payment schedule
    # https://api.iamport.kr/#!/subscribe/payments/again
    def subscribe_unschedule(body)
      pay_post("subscribe/payments/again", body)
    end

    private

    # Get header data
    def get_headers
      { "Authorization" => token }
    end

    # GET
    def pay_get(uri, payload = {})
      url = "#{IAMPORT_HOST}/#{uri}"

      HTTParty.get url, headers: get_headers, body: payload
    end

    # POST
    def pay_post(uri, payload = {})
      url = "#{IAMPORT_HOST}/#{uri}"

      HTTParty.post url, headers: get_headers, body: payload
    end
  end
end
