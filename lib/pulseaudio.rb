class PulseAudio
  def start
    read_sinks.each @sink_added
  end

  def on_sink_add(&block)
    @sink_added = block
  end

  def on_sink_remove(&block)
    @sink_removed = block
  end

  def on_input_add(&block)
    @input_added = block
  end

  def on_input_remove(&block)
    @input_removed = block
  end

  def move_input(input, sink)
  end

  def default_sink=(sink)
  end

  def read_sinks
    lines = `pactl list sinks | grep -e 'Sink #' -e 'Name' -e 'Description'`.lines
    sinks = []
    until lines.empty?
      number = lines.shift.sub(/Sink/, '').strip
      id = lines.shift.sub(/Name:/, '').strip
      title = lines.shift.sub(/Description:/, '').strip
      sinks.push Sink.new(id, number, title)
    end
    sinks
  end
end
