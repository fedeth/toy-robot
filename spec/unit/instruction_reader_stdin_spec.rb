# frozen_string_literal: true

require 'stringio'
require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe InstructionReaders::StandardInputReader do
    let(:stdin_reader) { InstructionReaders::StandardInputReader.new }

    def fake_io
      fake_io = StringIO.new
      fake_io.puts 'FOO bar,baz'
      fake_io.puts 'SPACE   this acts like a single param'
      fake_io.puts 'NOPARAMSHERE'
      fake_io.puts 'EXIT'
      fake_io.rewind
      fake_io
    end

    context 'when process an IO' do
      it 'parses the lines' do
        $stdin = fake_io
        yield_results = [
          ['FOO', ['bar', 'baz']],
          ['SPACE', ['thisactslikeasingleparam']],
          ['NOPARAMSHERE', []]
        ]
        expect { |block| stdin_reader.next_command(&block) }.to yield_control.exactly(3).times
        $stdin.rewind
        expect { |block| stdin_reader.next_command(&block) }.to yield_successive_args(*yield_results)
      end
    end
  end
end
