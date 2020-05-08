require 'concurrent'

require 'rogu/concern/logging'

module Rogu

  extend self

  def create_logger(level = Logger::FATAL, output = $stderr)
    lambda do |severity, progname, message = nil, &block|
      return false if severity < level

      message = block ? block.call : message
      formatted_message = case message
                          when String
                            message
                          when Exception
                            format "%s (%s)\n%s",
                                   message.message,
                                   message.class,
                                   (message.backtrace || []).join("\n")
                          else
                            message.inspect
                          end

      output.print format "%5s -- %s: %s\n",
                          Logger::SEV_LABEL[severity],
                          progname,
                          formatted_message
      true
    end
  end

  # Use logger created by #create_logger to log messages.
  def use_logger(level = Logger::FATAL, output = $stderr)
    Rogu.logger = create_logger(level, output)
  end

  GLOBAL_LOGGER = Concurrent::AtomicReference.new(create_logger(Logger::WARN))

  def logger
    GLOBAL_LOGGER.value
  end

  def logger=(log)
    GLOBAL_LOGGER.value = log
  end

end
