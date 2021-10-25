# frozen_string_literal: true

require_relative './../lib/robot_simulator'

command_reader = RobotSimulator::InstructionReaders::StandardInputReader.new
tabletop = RobotSimulator::Tabletop.new(5, 5)
game = RobotSimulator::Game.new(command_reader, tabletop)

# type EXIT to quit the game.
game.play
