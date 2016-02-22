require './ui.rb'
require './model.rb'

puts '-------------------------'
sinks = `pactl list short sinks`
sinks.each_line do |line|
    puts line
end
puts '-------------------------'

model = SwitchModel.new
SwitchUi.new(model)

model.add_sink Sink.new('sink1', 'Network')
model.add_sink Sink.new('sink2', 'Local')

Gtk.main
