require 'pty'

module AudioSwitch
  class Pactl
    def move_input(input_id, sink_id)
      `pactl move-sink-input #{input_id} #{sink_id}`
    end

    def default_sink=(sink_id)
      # pactl doesn't have this command
      `pacmd set-default-sink #{sink_id}`
    end

    def sinks
      self.class.parse_sinks(`pactl list sinks`)
    end

    def inputs
      self.class.parse_inputs(`pactl list inputs`)
    end

    def subscribe(command = 'pactl subscribe')
      @pactl_sub = PTY.spawn(command)[0]
      begin
        @pactl_sub.each do |line|
          yield self.class.parse_event(line)
        end
      rescue Errno::EIO, IOError
        return
      end
    end

    def dispose
      @pactl_sub.close
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

    def self.parse_inputs(out)
      out.split("\n")
         .select { |line| line =~ /^Sink Input #/ }
         .map { |line| { id: line.match(/#(\d+)$/)[1] } }
    end

    def self.parse_event(out_line)
      parts = out_line.split(' ')
      {
        type: parts[1].delete('\'').to_sym,
        object: parts[3].to_sym,
        id: parts[4].sub('#', '')
      }
    end
  end
end
