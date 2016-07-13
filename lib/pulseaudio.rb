module PulseAudioSwitch
  class PulseAudio
    def start
      parse_sinks.each @sink_added
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

    def sinks
      PulseAudio.parse_sinks(`pactl list sinks`)
    end

    def self.parse_sinks(out)
      sinks = []
      sink = nil
      out.each_line do |line|
        case line
        when /Sink #/
          sink = { id: line.sub(/Sink #/, '').strip }
        when /Name:/
          sink[:name] = line.sub(/Name:/, '').strip
        when /Description:/
          sink[:description] = line.sub(/Description:/, '').strip
          sinks << sink
          sink = nil
        end
      end
      sinks
    end
  end
end
