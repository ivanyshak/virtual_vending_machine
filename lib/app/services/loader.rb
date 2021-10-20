# frozen_string_literal: true

COMPONENTS = %w[
  ../models/database
  ../modules/questions
  ../system/errors_out
  ../system/io_handler
  ../system/presenter
  ./executor
].freeze

GEMS = %w[
  pry
  yaml
].freeze

GEMS.each { |gem| require gem }

COMPONENTS.each { |component| require_relative component }
