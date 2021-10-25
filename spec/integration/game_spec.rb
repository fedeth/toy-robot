# frozen_string_literal: true

require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe Game do
    before(:all) do
      @instructions = File.expand_path('../support/integration/commands.txt', __dir__)
    end

    context 'when initialized' do
      context 'with a 5 x 5 tabletop and a file with instructions' do
        let(:command_reader) { RobotSimulator::InstructionReaders::FileReader.new(@instructions) }
        let(:tabletop) { RobotSimulator::Tabletop.new(5, 5) }

        it 'prints the expected output' do
          expected_output = "X: 0, Y: 0, NORTH\n" \
                            "X: 0, Y: 4, NORTH\n" \
                            "X: 0, Y: 4, NORTH\n" \
                            "X: 2, Y: 4, EAST\n" \
                            "X: 2, Y: 4, EAST\n" \
                            "X: 4, Y: 4, WEST\n" \

          sample_game = Game.new(command_reader, tabletop)
          expect { sample_game.play }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
