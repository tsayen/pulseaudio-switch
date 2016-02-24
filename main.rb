require './ui.rb'
require './model.rb'

model = SwitchModel.new
SwitchUi.new(model)

model.enable

Gtk.main
