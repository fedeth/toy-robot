# frozen_string_literal: true

module RobotSimulator
  module TableBaseValidations
    def inside_the_table?(pos_x, pos_y)
      valid_x = pos_x.is_a?(Integer) && !pos_x.negative? && pos_x < width
      valid_y = pos_y.is_a?(Integer) && !pos_y.negative? && pos_y < length
      valid_x && valid_y
    end
  end

  class Tabletop
    attr_reader :length, :width

    include TableBaseValidations

    def initialize(length = 5, width = 5)
      raise InvalidInitializationError unless length.is_a?(Integer) && length.positive?
      raise InvalidInitializationError unless width.is_a?(Integer) && width.positive?

      @length = length
      @width = width
    end

    def allowed_move?(pos_x, pos_y)
      inside_the_table?(pos_x, pos_y)
    end
  end

  # naive implementation of maps with walls
  class TableMap
    attr_reader :length, :width, :wall_char, :obstacles

    include TableBaseValidations

    def initialize(file, wall_char = '#')
      raise StandardError, 'file does not exist' unless File.file?(file)

      @wall_char = wall_char
      @length, @width, @obstacles = parse_map(file)
    end

    def allowed_move?(pos_x, pos_y)
      inside_the_table?(pos_x, pos_y) && !obstacles.include?("#{pos_x}:#{pos_y}")
    end

    def parse_map(file)
      walls = []
      width = nil
      File.open(file) do |f|
        while (line = f.gets)
          line_size = line.gsub(/\n/, '').size
          width ||= line_size
          raise MalformedMapError if width != line_size

          walls << build_walls_array(line)
        end
      end

      # walls.reverse is necessary to mantain the correct orientation
      [walls.length, width, build_obstacle_set(walls.reverse)]
    end

    private

    def build_walls_array(line)
      wall_positions = []
      line.each_char.with_index do |char, ind|
        wall_positions << ind if char == wall_char
      end
      wall_positions
    end

    def build_obstacle_set(walls)
      obstacles = Set.new
      walls.each_with_index do |walls_line, pos_y|
        walls_line.each do |pos_x|
          obstacles.add("#{pos_x}:#{pos_y}")
        end
      end
      obstacles
    end
  end
end
