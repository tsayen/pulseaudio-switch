require './ui.rb'
require './model.rb'

def read_sinks
    lines = `pactl list sinks | grep -e 'Name' -e 'Description'`.lines
    sinks = []
    while lines.size > 0
        id = lines.shift.sub(/Name:/, '').strip
        name = lines.shift.sub(/Description:/, '').strip
        sinks.push Sink.new(id, name)
    end
    sinks
end

model = SwitchModel.new
SwitchUi.new(model)

read_sinks.each do |sink|
    model.add_sink sink
    puts 'adding sink ' + sink.inspect
end

Gtk.main
