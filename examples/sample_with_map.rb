# frozen_string_literal: true

require_relative './../lib/robot_simulator'

# ------ MAP ------
#
#  |@     @@@    @|
#  |@  @@@@@@  @@@|
#  |@  @@        @|
#  |           @@ |
#  |@          @  |
#  |@          @  |
#  | @@   @@    @@|
#

map_file = File.expand_path('table_map_sample.txt', __dir__)
tabletop = RobotSimulator::TableMap.new(map_file, '@')
command_reader = RobotSimulator::InstructionReaders::StandardInputReader.new
game = RobotSimulator::Game.new(command_reader, tabletop)

# type EXIT to quit the game.
game.play
