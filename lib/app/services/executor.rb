# frozen_string_literal: true

class Executor
  BALANCE = 'balance'

  attr_accessor :database

  def initialize(database)
    @database = database
  end

  def machine_balance
    database.banknotes.map { |k, v| k * v }.sum
  end

  def machine_banknotes
    database.banknotes
  end

  def machine_products
    database.products
  end

  def is_quantity_positive?(selected)
    (selected['quantity']).positive?
  end

  def recount_change(change)
    change = change
    result = nil

    machine_banknotes.each do |value, qty|
      count = qty
      count.times do
        change = result || change

        next if value > change

        count -= 1
        result = change - value
        machine_banknotes[value] = count
      end
    end
    update_cash(machine_banknotes)
  end

  def update_cash(bill)
    database.banknotes_update(bill)
  end

  def update_products(product)
    product['quantity'] -= 1
  end

  def save(config)
    database.update(config)
  end
end
