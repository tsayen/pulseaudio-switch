require 'logger'

module AudioSwitch
  LOG = Logger.new(STDOUT)
  LOG.level = Logger::FATAL
end
