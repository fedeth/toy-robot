# frozen_string_literal: true

module RobotSimulator
  module InstructionReaders
    class StandardInputReader
      def next_command
        loop do
          input = gets.chomp.strip
          command, options_array = input.split(' ', 2)
          params = options_array ? options_array.delete(' ').split(',') : []
          break if command == 'EXIT'

          yield command, params
        end
      end
    end

    class FileReader
      attr_reader :file

      def initialize(file)
        raise StandardError, 'file does not exist' unless File.file?(file)

        @file = file
      end

      def next_command
        File.foreach(file) do |line|
          command, options_array = line.delete("\n").split(' ', 2)
          params = options_array ? options_array.delete(' ').split(',') : []
          next if command.nil?

          yield command, params
        end
      end
    end

    class EmailReader
      def initialize
        # Mail.defaults do
        #   retriever_method :pop3, :address    => "pop.gmail.com",
        #                           :port       => 995,
        #                           :user_name  => '<username>',
        #                           :password   => '<password>',
        #                           :enable_ssl => true
        raise NotImplementedError
      end

      def next_command
        # polling the mail server
        # last_email = Mail.last
        # command, params = parse(last_email.body)
        # yield command, params
        raise NotImplementedError
      end
    end
  end
end
