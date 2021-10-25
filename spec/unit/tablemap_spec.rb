# frozen_string_literal: true

require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe TableMap do
    context 'when initialized' do
      context 'with a missing file' do
        missing_map_file = File.expand_path('../support/unit/missing_sample_map.txt', __dir__)
        let(:table_map) { TableMap.new(missing_map_file) }

        it 'raises an error' do
          expect { table_map }.to raise_error(StandardError, 'file does not exist')
        end
      end

      context 'with a bad map file' do
        malformed_map_file = File.expand_path('../support/unit/sample_map_wrong.txt', __dir__)
        let(:table_map) { TableMap.new(malformed_map_file) }

        it 'raises an error' do
          expect { table_map }.to raise_error(MalformedMapError)
        end
      end

      context 'with a map file' do
        map_file = File.expand_path('../support/unit/sample_map.txt', __dir__)
        let(:table_map) { TableMap.new(map_file) }

        it 'has a length' do
          expect(table_map.length).to eq(7)
        end

        it 'has a width' do
          expect(table_map.width).to eq(14)
        end

        it 'has a set of walls' do
          expect(table_map.obstacles).to be_a Set
          expect(table_map.obstacles.count).to be(31)
        end
      end

      context 'when it checks if a move is allowed' do
        map_file = File.expand_path('../support/unit/sample_map.txt', __dir__)
        let(:table_map) { TableMap.new(map_file) }

        context 'with a valid move' do
          it 'exepects to return true' do
            expect(table_map.allowed_move?(2, 5)).to be true
          end
        end

        context 'with a invalid move' do
          it 'exepects to return false' do
            expect(table_map.allowed_move?(0, 6)).to be false
          end
        end
      end
    end
  end
end
