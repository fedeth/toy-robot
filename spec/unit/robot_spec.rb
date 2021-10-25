# frozen_string_literal: true

require 'stringio'
require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe Robot do
    context 'when initialized' do
      let(:robot) { Robot.new(instance_double(Tabletop)) }

      it 'has a nil state' do
        expect(robot.state).to be nil
      end

      it 'allows PLACE command' do
        expect(robot.allowed_command?('PLACE')).to be true
      end

      it "doesn't allow any other command" do
        Robot::ALLOWED_COMMANDS
          .reject { |command| command == 'PLACE' }.each do |command|
          expect(robot.allowed_command?(command)).to be(false)
        end
      end
    end

    context 'when it has a valid state' do
      let(:robot) { Robot.new(instance_double(Tabletop)) }

      it 'allows any command' do
        allow(robot).to receive(:state).and_return(instance_double(Robot::State))
        Robot::ALLOWED_COMMANDS.each do |command|
          expect(robot.allowed_command?(command)).to be(true)
        end
      end
    end

    context 'when PLACE command is called' do
      let(:state) { double(Robot::State) }

      context 'with valid params' do
        let(:tabletop_double) do
          d_tabletop = double(Tabletop)
          allow(d_tabletop).to receive(:allowed_move?).and_return(true)
          d_tabletop
        end

        it 'calls new state' do
          allow(Robot::State).to receive(:new) { state }

          robot = Robot.new(tabletop_double)
          expect(Robot::State).to receive(:new)
          robot.command_place(1, 1, 'NORTH')
        end
      end

      context 'with invalid params' do
        let(:tabletop_double) do
          d_tabletop = double(Tabletop)
          allow(d_tabletop).to receive(:allowed_move?).and_return(false)
          d_tabletop
        end

        it "doesn't call new state" do
          allow(Robot::State).to receive(:new) { state }

          robot = Robot.new(tabletop_double)
          expect(Robot::State).to_not receive(:new)
          robot.command_place(-1, 1, 'NORTH')
        end
      end
    end

    context 'when MOVE command is called' do
      let(:robot) { Robot.new(tabletop_double) }

      let(:tabletop_double) do
        d_tabletop = double(Tabletop)
        allow(d_tabletop).to receive(:allowed_move?).and_return(true)
        d_tabletop
      end

      let(:state) do
        d_state = double(Robot::State)
        allow(d_state).to receive(:pos_x).and_return 0
        allow(d_state).to receive(:pos_y).and_return 0
        allow(d_state).to receive(:orientation).and_return 'NORTH'
        allow(d_state).to receive(:update_position)
        d_state
      end

      it 'calls update_position with valid data' do
        allow(robot).to receive(:state).and_return(state)
        expect(state).to receive(:update_position).with(0, 1)
        robot.command_move
      end
    end

    context 'when LEFT command is called' do
      let(:robot) { Robot.new(instance_double(Tabletop)) }
      it 'delegate the operation to the state' do
        allow(robot).to receive_message_chain(:state, :rotate_left!)
        expect(robot.state).to receive(:rotate_left!)
        robot.command_left
      end
    end

    context 'when RIGHT command is called' do
      let(:robot) { Robot.new(instance_double(Tabletop)) }
      it 'delegate the operation to the state' do
        allow(robot).to receive_message_chain(:state, :rotate_right!)
        expect(robot.state).to receive(:rotate_right!)
        robot.command_right
      end
    end

    context 'when REPORT command is called' do
      let(:robot) { Robot.new(instance_double(Tabletop)) }
      let(:state) do
        d_state = double(Robot::State)
        allow(d_state).to receive(:pos_x).and_return 1
        allow(d_state).to receive(:pos_y).and_return 2
        allow(d_state).to receive(:orientation).and_return 'NORTH'
        d_state
      end

      it 'prints the robot state' do
        allow(robot).to receive(:state).and_return(state)
        expect { robot.command_report }.to output("X: 1, Y: 2, NORTH\n").to_stdout
      end
    end
  end
end
