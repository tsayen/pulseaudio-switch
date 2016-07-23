require 'pty'

module AudioSwitch
  class Pactl
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

    def subscribe(command = 'pactl subscribe')
      @pactl_sub_out, @pactl_sub_in = PTY.spawn(command)
      begin
        @pactl_sub_out.each do |line|
          yield self.class.parse_event(line)
        end
      rescue Errno::EIO, IOError
        return
      end
    end

    def unsubscribe
      @pactl_sub_out.close
      @pactl_sub_in.close
    end

    def self.parse_sinks(out)
      sinks = []
      sink = nil
      out.each_line do |line|
        case line
        when /Sink #/
          sink = { id: line.sub(/Sink/, '').strip }
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

    def self.parse_event(out_line)
      parts = out_line.split(' ')
      {
        type: parts[1].delete('\'').to_sym,
        object: parts[3].to_sym,
        id: parts[4]
      }
    end
  end
end
