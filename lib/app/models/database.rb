# frozen_string_literal: true

# bank_data_base.rb
# Database class defined for
# storing all information about
# users, accounts, transactions
class Database
  BANKNOTES   = 'banknotes'
  PRODUCTS    = 'products'

  def initialize(database = {})
    @banknotes = database.fetch(BANKNOTES)
    @products  = database.fetch(PRODUCTS)
  end

  attr_reader :banknotes, :products

  def to_h
    {
      PRODUCTS => products,
      BANKNOTES => banknotes
    }
  end

  def banknotes_update(options)
    @banknotes.merge!(options)
  end

  def update(config)
    File.open(config.to_s, 'r+') do |file|
      file.write(to_h.to_yaml)
    end
  end
end
