module PayU
  module Errors
    RequestFailure = Class.new(StandardError)
    TimeoutError   = Class.new(StandardError)
    ServerError    = Class.new(StandardError)
  end
end