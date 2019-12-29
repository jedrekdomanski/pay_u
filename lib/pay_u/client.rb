module PayU
  class Client < Service
    class << self
      def create_order(params)
        Requests::CreateOrder.call(params: params)
      end

      def find_order(id)
        Requests::GetOrder.call(order_id: id)
      end

      def payment_methods
        Requests::PaymentMethods.call
      end

      def cancel_order(id)
        Requests::CancelOrder.call(order_id: id)
      end
    end
  end
end
