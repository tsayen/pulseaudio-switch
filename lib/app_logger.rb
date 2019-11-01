module AudioSwitch
  def self.configure_logger
    log_path = "#{Dir.home}/.audio_switch"
    Dir.mkdir(log_path) unless Dir.exist?(log_path)
    log = Logger.new("#{log_path}/audio_switch.log", 'daily')
    log.level = Logger::INFO
    log
  end
end
