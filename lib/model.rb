module PulseAudioSwitch
  class Model
    def initialize
      @sinks = {}
    end

    def watch(&block)
      @update = block
      @update.call
    end

    def add_sink(sink)
      @sinks[sink.id] = sink
      @sink_added.call(sink) if @sink_added
    end

    def select_sink(sink_id)
      @current_sink = sink_id
      puts sink_id
    end

    def sinks
      lines = `pactl list sinks | grep -e 'Sink #' -e 'Name' -e 'Description'`.lines
      sinks = []
      until lines.empty?
        number = lines.shift.sub(/Sink/, '').strip
        id = lines.shift.sub(/Name:/, '').strip
        title = lines.shift.sub(/Description:/, '').strip

        sinks.push(id: id, number: number, title: title)
      end
      sinks
    end
  end
end
