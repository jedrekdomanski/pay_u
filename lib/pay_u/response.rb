module PayU
  module Response
    class OrderFound
      def initialize(response:)
        @response = response
        @order = response.body['orders'].first
      end

      def order_id
        @order['orderId']
      end

      def order_created_at
        @order['orderCreateDate']
      end

      def notify_url
        @order['notifyUrl']
      end

      def customer_ip
        @order['customerIp']
      end

      def merchant_pos_id
        @order['merchantPosId']
      end

      def description
        @order['description']
      end

      def currency_code
        @order['currencyCode']
      end

      def total_amount
        @order['totalAmount']
      end

      def status
        @response.body['status']['statusDesc']
      end

      def products
        @order['products']
      end
    end

    class OrderNotFound
      def initialize(response:)
        @response = response
        @data = response.body['status']
      end

      def status
        @data['statusCode']
      end

      def description
        @data['statusDesc']
      end
    end
  end
end
