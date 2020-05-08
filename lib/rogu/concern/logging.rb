require 'logger'

module Rogu
  module Concern
    # Enable logging where needed.
    #
    # Modified version of the Concurrent::Concern::Logging module, without
    # the timestamp field as it is automatically added by Heroku.
    module Logging

      include Logger::Severity

      # Logs through {Concurrent.global_logger}, it can be overridden by setting @logger
      # @param [Integer] level one of Logger::Severity constants
      # @param [String] progname e.g. a path of an Actor
      # @param [String, nil] message when nil block is used to generate the message
      # @yieldreturn [String] a message
      def log(level, progname, message = nil, &block)
        logger = ::Rogu.logger

        logger.call(level, progname, message, &block)
      rescue => error
        $stderr.puts "`Rogu.logger` failed to log #{[level, progname, message, block]}\n" +
                     "#{error.message} (#{error.class})\n#{error.backtrace.join "\n"}"
      end

    end
  end
end
