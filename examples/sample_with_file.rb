# frozen_string_literal: true

require_relative './../lib/robot_simulator'

command_reader = RobotSimulator::InstructionReaders::FileReader
                 .new(File.expand_path('./instruction_sample.txt', __dir__))

tabletop = RobotSimulator::Tabletop.new(5, 5)
game = RobotSimulator::Game.new(command_reader, tabletop)

game.play
