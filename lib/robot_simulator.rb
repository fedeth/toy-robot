# frozen_string_literal: true

require 'set'
require_relative './robot_simulator/instruction_readers'
require_relative './robot_simulator/robot'
require_relative './robot_simulator/tabletops'
require_relative './robot_simulator/custom_errors'

module RobotSimulator
  class Game
    attr_reader :robot, :command_reader

    def initialize(command_reader, tabletop, robot_class = Robot)
      @robot = robot_class.new(tabletop)
      @command_reader = command_reader
    end

    def play
      command_reader.next_command do |command, params|
        robot.send("command_#{command.downcase}", *params) if robot.allowed_command?(command)
      rescue ArgumentError
        puts '(invalid numer of arguments for this command)'
      end
    end
  end
end
