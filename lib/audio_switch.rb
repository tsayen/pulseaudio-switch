require_relative 'audio_switch/pactl.rb'
require_relative 'audio_switch/model.rb'
require_relative 'audio_switch/ui.rb'
require_relative 'audio_switch/version.rb'

module AudioSwitch
  module App
    def self.start
      pactl = AudioSwitch::Pactl.new
      model = AudioSwitch::Model.new(pactl)
      ui = AudioSwitch::UI.new(model)
      ui.start
    end
  end
end
