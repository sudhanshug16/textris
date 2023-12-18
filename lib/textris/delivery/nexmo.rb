module Textris
  module Delivery
    class Nexmo < Textris::Delivery::Base
      def deliver(phone)
        client.sms.send(
          from: sender_id,
          to:   phone,
          text: message.content
        )
      end

      private
        def client
          @client ||= ::Nexmo::Client.new(api_key: Rails.application.credentials.nexmo[:production][:api_key], api_secret: Rails.application.credentials.nexmo[:production][:api_secret])
        end

        def sender_id
          message.from_phone || message.from_name
        end
    end
  end
end
