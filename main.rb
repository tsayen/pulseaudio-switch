require './ui.rb'
require './model.rb'

def read_sinks
    lines = `pactl list sinks | grep -e 'Sink #' -e 'Name' -e 'Description'`.lines
    sinks = []
    while lines.size > 0
        number = lines.shift.sub(/Sink/, '').strip
        id = lines.shift.sub(/Name:/, '').strip
        title = lines.shift.sub(/Description:/, '').strip
        sinks.push Sink.new(id, number, title)
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
