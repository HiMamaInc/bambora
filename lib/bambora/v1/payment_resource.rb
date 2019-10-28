# frozen_string_literal: true

module Bambora
  module V1
    class PaymentResource
      def initialize(client:)
        @client = client
        @sub_path = '/v1/payments'
      end

      def make_payment(payment_data)
        @client.request(method: :post, path: @sub_path, body: payment_data)
      end

      def make_payment_with_payment_profile(customer_code:, amount:)
        make_payment(
          amount: amount,
          payment_method: 'payment_profile',
          payment_profile: {
            customer_code: customer_code,
            card_id: 1,
          },
        )
      end
    end
  end
end
