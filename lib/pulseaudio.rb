module PulseAudioSwitch
  class PulseAudio
    def start
      parse_sinks.each @sink_added
    end

    def move_input(input, sink)
    end

    def default_sink=(sink)
    end

    def sinks
      self.class.parse_sinks(`pactl list sinks`)
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
