# frozen_string_literal: true

require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe Robot::State do
    context 'when initialized correctly' do
      let(:state) { Robot::State.new(1, 2, 'EAST') }

      it 'has a valid x_pos' do
        expect(state.pos_x).to eq(1)
      end

      it 'has a valid y_pos' do
        expect(state.pos_y).to eq(2)
      end

      it 'has a valid orientation' do
        expect(state.orientation).to eq('EAST')
      end
    end

    context 'when not initialized correctly' do
      context 'with a wrong orientation' do
        let(:state_wrong_o9n) { Robot::State.new(1, 2, 'EST') }

        it 'raises an error' do
          expect { state_wrong_o9n }.to raise_error(InvalidOrientationError)
        end
      end

      context 'with wrong coordinates' do
        let(:state_wrong_c9s) { Robot::State.new(-1, 2, 'NORTH') }

        it 'raises an error' do
          expect { state_wrong_c9s }.to raise_error(InvalidCoordsError)
        end
      end
    end

    context 'when update the position' do
      let(:state) { Robot::State.new(0, 0, 'SOUTH') }

      it 'fails with wrong input' do
        expect { state.update_position(-1, 3) }.to raise_error(InvalidCoordsError)
      end

      it 'succeeds with the right input' do
        state.update_position(100, 200)

        expect(state.pos_x).to eq(100)
        expect(state.pos_y).to eq(200)
      end
    end

    context 'when it rotates' do
      let(:state) { Robot::State.new(0, 0, 'NORTH') }

      it 'performs right rotations' do
        state.rotate_right!
        expect(state.orientation).to eq('EAST')
        state.rotate_right!
        expect(state.orientation).to eq('SOUTH')
        state.rotate_right!
        expect(state.orientation).to eq('WEST')
        state.rotate_right!
        expect(state.orientation).to eq('NORTH')
      end

      it 'performs left rotations' do
        state.rotate_left!
        expect(state.orientation).to eq('WEST')
        state.rotate_left!
        expect(state.orientation).to eq('SOUTH')
        state.rotate_left!
        expect(state.orientation).to eq('EAST')
        state.rotate_left!
        expect(state.orientation).to eq('NORTH')
      end
    end
  end
end
