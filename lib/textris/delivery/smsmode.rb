require "net/http"

module Textris
  module Delivery
    class Smsmode < Textris::Delivery::Base
      def deliver(phone)
        Rails.logger.info("je passe dans deliver")
        send_sms(phone)
      end

      private
        def send_sms(phone)
          Rails.logger.info("je passe dans send_sms")
          Rails.logger.info("Numéro de téléphone : #{phone}}")
          Rails.logger.info("Message : #{message.content}}")
          Rails.logger.info("Expéditeur : #{sender}}")

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
          Rails.logger.info("je passe dans post_message")

          url = URI("https://rest.smsmode.com/sms/v1/messages")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["X-Api-Key"] = Rails.application.credentials.smsmode[:api_key]
          request["Content-Type"] = "application/json"
          request["Accept"] = "application/json"
          request.body = JSON.dump(payload)

          response = https.request(request)
          Rails.logger.info("Réponse de la requête : #{response.read_body}")
        end

        def sender
          message.from_name
        end
    end
  end
end
