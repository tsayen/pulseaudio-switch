require './ui.rb'
require './model.rb'

model = SwitchModel.new
ui = SwitchUi.new(model) do

ui.start