# frozen_string_literal: true

module RobotSimulator
  class Robot
    ALLOWED_COMMANDS = Set.new(%w[PLACE MOVE LEFT RIGHT REPORT]).freeze
    ORIENTATION_TO_MOVE = {
      'NORTH' => [0, 1],
      'EAST' => [1, 0],
      'SOUTH' => [0, -1],
      'WEST' => [-1, 0]
    }.freeze

    # Internal robot state
    class State
      attr_reader :pos_x, :pos_y, :orientation

      ORIENTATIONS = ORIENTATION_TO_MOVE.keys.freeze

      def initialize(pos_x, pos_y, orientation)
        raise InvalidOrientationError unless ORIENTATIONS.include?(orientation)
        raise InvalidCoordsError unless coords_valid?(pos_x, pos_y)

        @pos_x = pos_x
        @pos_y = pos_y
        @orientation = orientation
      end

      def update_position(new_x = pos_x, new_y = pos_y)
        raise InvalidCoordsError unless coords_valid?(new_x, new_y)

        @pos_x = new_x
        @pos_y = new_y
      end

      def rotate_right!
        index = ORIENTATIONS.index(orientation)
        @orientation = ORIENTATIONS[(index + 1) % 4]
      end

      def rotate_left!
        index = ORIENTATIONS.index(orientation)
        @orientation = ORIENTATIONS[(index - 1) % 4]
      end

      private

      def coords_valid?(pos_x, pos_y)
        pos_x.is_a?(Integer) && !pos_x.negative? && pos_y.is_a?(Integer) && !pos_y.negative?
      end
    end

    attr_reader :state, :tabletop

    def initialize(tabletop)
      @state = nil
      @tabletop = tabletop
    end

    # PLACE x,y,F
    def command_place(pos_x, pos_y, orientation)
      pos_x = pos_x.to_i
      pos_y = pos_y.to_i
      @state = State.new(pos_x, pos_y, orientation) if tabletop.allowed_move?(pos_x, pos_y)
    rescue InvalidCoordsError
      puts '(invalid coords)'
    rescue InvalidOrientationError
      puts '(invalid orientation)'
    end

    # MOVE
    def command_move
      new_x = state.pos_x + ORIENTATION_TO_MOVE[state.orientation][0]
      new_y = state.pos_y + ORIENTATION_TO_MOVE[state.orientation][1]
      state.update_position(new_x, new_y) if tabletop.allowed_move?(new_x, new_y)
    end

    # LEFT
    def command_left
      state.rotate_left!
    end

    # RIGHT
    def command_right
      state.rotate_right!
    end

    # REPORT
    def command_report
      puts "X: #{state.pos_x}, Y: #{state.pos_y}, #{state.orientation}"
    end

    def allowed_command?(command)
      if state.nil?
        command.eql?('PLACE')
      else
        ALLOWED_COMMANDS.include?(command)
      end
    end
  end
end
