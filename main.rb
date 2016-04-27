require './ui.rb'
require './model.rb'

model = SwitchModel.new
UI.new(model)

Gtk.main
