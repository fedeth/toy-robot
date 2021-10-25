# frozen_string_literal: true

require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe Tabletop do
    context 'when initialized correctly' do
      let(:tabletop) { RobotSimulator::Tabletop.new(6, 7) }

      it 'has a length' do
        expect(tabletop.length).to eq(6)
      end

      it 'has a width' do
        expect(tabletop.width).to eq(7)
      end
    end

    context 'when not initialized correctly' do
      let(:bad_tabletop) { RobotSimulator::Tabletop.new(0, 7) }

      it 'raises an error' do
        expect { bad_tabletop }.to raise_error(InvalidInitializationError)
      end
    end

    context 'when check if a move is allowed' do
      let(:tabletop) { RobotSimulator::Tabletop.new(3, 3) }

      context 'whit a valid move' do
        it 'exepcts to return true' do
          expect(tabletop.allowed_move?(2, 2)).to be true
        end
      end

      context 'whit a invalid move' do
        it 'exepcts to return false' do
          expect(tabletop.allowed_move?(3, 4)).to be false
        end
      end
    end
  end
end
