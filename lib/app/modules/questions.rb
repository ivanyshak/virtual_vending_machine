# frozen_string_literal: true

module Questions
  def ask_select_product
    stream.print_output('Please Enter Number of Product you want to choose:')
    stream.read_input.to_i
  end

  def ask_for_money
    stream.print_output('Please Type the number of Money you want to put: (for ex. 12.0)')
    stream.read_input.to_f
  end
end
