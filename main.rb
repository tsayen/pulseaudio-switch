require './ui.rb'
require './model.rb'

model = SwitchModel.new
PulseAudioSwitch::UI.new(model)

Gtk.main
