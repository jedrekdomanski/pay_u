module PayU
  module Response
    class OrderFound
      attr_reader :order_id, :order_created_date, :notify_url,
                  :customer_ip, :merchant_pos_id, :description,
                  :currency_code, :total_amount, :status, :products

      def initialize(
        order_id:, order_created_date:, notify_url:,
        customer_ip:, merchant_pos_id:, description:,
        currency_code:, total_amount:, status:, products:
      )
        @order_id = order_id
        @order_created_date = order_created_date
        @notify_url = notify_url
        @customer_ip = customer_ip
        @merchant_pos_id = merchant_pos_id
        @description = description
        @currency_code = currency_code
        @total_amount = total_amount
        @status = status
        @products = products
      end
    end

    class OrderNotFound
      attr_reader :status, :severity, :description

      def initialize(status:, severity:, description:)
        @status = status
        @severity = severity
        @description = description
      end
    end
  end
end
