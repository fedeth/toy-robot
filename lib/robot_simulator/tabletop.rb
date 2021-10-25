# frozen_string_literal: true

module RobotSimulator
  class Tabletop
    attr_reader :length, :width

    def initialize(length = 5, width = 5)
      raise InvalidInitializationError unless length.is_a?(Integer) && length.positive?
      raise InvalidInitializationError unless width.is_a?(Integer) && width.positive?

      @length = length
      @width = width
    end

    def allowed_move?(pos_x, pos_y)
      valid_x = pos_x.is_a?(Integer) && !pos_x.negative? && pos_x < width
      valid_y = pos_y.is_a?(Integer) && !pos_y.negative? && pos_y < length
      valid_x && valid_y
    end
  end
end
