# frozen_string_literal: true

# presenter.rb
class Presenter
  include Questions

  attr_accessor :service, :stream, :error

  def initialize(service)
    @service = service
    @stream  = InputOutputHandler.new
    @error   = ErrorsOut.new
  end

  def call
    login
  end

  private

  def login
    stream.print_output("Welcome to #{app_name}!")
    menu
  end

  def app_name
    'Virtual Vending Machine'
  end

  def show_balance
    current_balance_info(service.machine_balance)
    menu
  end

  def select_product
    machine_products_info(service.machine_products)
    choose = ask_select_product
    display_product(choose)
  end

  def display_product(choose)
    choosed = service.machine_products[choose]

    if service.is_quantity_positive?(choosed)
      stream.print_output("Your choose is #{choosed['name']}. You should pay #{choosed['price']}$")

      inserted_amount = ask_for_money
      change_calculation(inserted_amount, choosed)
    else
      stream.print_output(error.product_is_absent)
      menu
    end
  end

  def logout
    stream.print_output('Thank You For Using Our Virtual Vending Machine. Good-Bye!')
    service.save(CONFIG)
    login
  end

  def menu
    stream.print_output("Please Choose From the Following Options:\n
    1. Display Balance\n\
    2. Select Product\n\
    3. Log Out\n")
    menu_choose_action
  end

  def menu_choose_action
    choose = stream.read_input
    case choose.to_i
    when 1  then  show_balance
    when 2  then  select_product
    when 3  then  logout
    end
  end

  def change_calculation(inserted, product)
    change = inserted - product['price']

    if change > service.machine_balance
      stream.print_output(error.is_negative_balance)
    else
      update_balance(change)
      update_product(product)

      stream.print_output("You invested #{inserted}$ Your change is #{change}\nThank you for your order!")
    end
    menu
  end

  def update_balance(change)
    service.recount_change(change)
  end

  def update_product(product)
    service.update_products(product)
  end

  def current_balance_info(balance = {})
    stream.print_output("Machine Current Balance is #{balance}")
  end

  def machine_products_info(products = {})
    products.each do |key, product|
      stream.print_output("#{key} - Name #{product['name']} - #{product['price']}$")
    end
  end
end
