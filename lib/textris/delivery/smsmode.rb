require "net/http"

module Textris
  module Delivery
    class Smsmode < Textris::Delivery::Base
      def deliver(phone)
        send_sms(phone)
      end

      private
        def send_sms(phone)
          payload = {
            "recipient": {
              "to": phone
            },
            "body": {
              "text": message.content
            },
            "from": sender
          }

          post_message(payload)
        end

        def post_message(payload)
          url = URI("https://rest.smsmode.com/sms/v1/messages")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["X-Api-Key"] = Rails.application.credentials.smsmode[:api_key]
          request["Content-Type"] = "application/json"
          request["Accept"] = "application/json"
          request.body = JSON.dump(payload)

          response = https.request(request)
          body = JSON.parse(response.body)

          unless body["status"]["deliveryDate"].present?
            error_message = "Error while calling SMSMode API: #{body["status"]} - #{body["message"]}"
            raise error_message
          end
        end

        def sender
          message.from_name
        end
    end
  end
end
