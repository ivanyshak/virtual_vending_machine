# frozen_string_literal: true

class ErrorsOut
  def initialize; end

  def is_negative_balance
    'MACHINE BALANCE IS LESS THAN YOUR CHANGE - PLEASE BUY ONE MORE PRODUCT!'
  end

  def product_is_absent
    'ThE PRODUCT IN ThE MACHINE HAS ALREADY RUN OUT!'
  end
end
