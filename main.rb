require './ui.rb'
require './model.rb'

model = PulseAudioSwitch::Model.new
PulseAudioSwitch::UI.new(model)

Gtk.main
