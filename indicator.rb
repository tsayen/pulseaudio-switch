require './ui.rb'
require './model.rb'

model = SwitchModel.new
SwitchUi.new(model)

model.add_sink Sink.new('sink1', 'Network')
model.add_sink Sink.new('sink2', 'Local')

Gtk.main
