# frozen_string_literal: true

# io_handler.rb
class InputOutputHandler
  def read_input
    $stdin.gets.chomp
  end

  def print_output(text)
    $stdout.puts text
  end
end
