# frozen_string_literal: true

require_relative '../../lib/robot_simulator'

module RobotSimulator
  RSpec.describe InstructionReaders::FileReader do
    context 'when initialized without a filename' do
      let(:file_reader_fail) { InstructionReaders::FileReader.new }

      it 'raises an error' do
        expect { file_reader_fail }.to raise_error(ArgumentError)
      end
    end

    context 'when initialized with a non-existent filename' do
      let(:file_reader_fail) { InstructionReaders::FileReader.new('foobar.txt') }
      it 'raises an error' do
        expect { file_reader_fail }.to raise_error(StandardError, 'file does not exist')
      end
    end

    context 'when initialized correctly' do
      path = File.expand_path('../support/unit/file_reader.txt', __dir__)
      let(:file_reader) { InstructionReaders::FileReader.new(path) }

      it 'has a file attribute' do
        expect(file_reader.file).to match(/.*file_reader.txt$/)
      end

      it 'skips empty lines' do
        expect { |block| file_reader.next_command(&block) }.to yield_control.exactly(4).times
      end

      it 'parses a file' do
        # [command, [params]]
        yield_results = [
          ['FOO', ['bar', 'baz']],
          ['SPACE', ['thisactslikeasingleparam']],
          ['NOPARAMSHERE', []],
          ['THE', ['previous', 'line', 'has', 'been', 'skipped']]
        ]
        expect { |block| file_reader.next_command(&block) }.to yield_successive_args(*yield_results)
      end
    end
  end
end
