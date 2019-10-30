require 'logger'
require_relative 'audio_switch/pactl.rb'
require_relative 'audio_switch/model.rb'
require_relative 'audio_switch/ui.rb'
require_relative 'audio_switch/version.rb'

module AudioSwitch
  LOG = Logger.new("#{Dir.home}/.audio_switch/audio_switch.log", 'daily')
  LOG.level = Logger::INFO

  module App
    def self.start
      AudioSwitch::LOG.info("starting audio_switch #{AudioSwitch::VERSION} on ruby #{RUBY_VERSION}")
      pactl = AudioSwitch::Pactl.new
      model = AudioSwitch::Model.new(pactl)
      ui = AudioSwitch::UI.new(model)
      ui.start
    end

    def self.quit
      AudioSwitch::LOG.info('quitting audio_switch')
      exit
    end
  end
end
