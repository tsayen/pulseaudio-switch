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
      default_sink_name = self.class.parse_default_sink(`pactl stat`)
      self.class.parse_sinks(`pactl list sinks`, default_sink_name)
    end

    def inputs
      self.class.parse_inputs(`pactl list sink-inputs`)
    end

    def modules
      self.class.parse_modules(`pactl list modules`)
    end

    def load_module(mod, options = {})
      `pactl load-module #{mod} #{self.class.format_module_opts(options)}`
    end

    def unload_module(mod)
      `pactl unload-module #{mod}`
    end

    def subscribe(command = 'pactl subscribe')
      Thread.start do
        @pactl_sub = PTY.spawn(command)[0]
        begin
          @pactl_sub.each do |line|
            yield(self.class.parse_event(line))
          end
        rescue Errno::EIO, IOError
          return
        end
      end
    end

    def dispose
      @pactl_sub.close
    end

    def self.format_module_opts(opts, quote = '')
      result = ''
      opts.each_pair do |key, value|
        result += ' ' unless result.empty?
        result += if value.is_a? Hash
                    "#{key}=\\\"#{format_module_opts(value, '\\\'')}\\\""
                  else
                    "#{key}=#{quote}#{value}#{quote}"
                  end
      end
      result
    end

    def self.parse_sinks(out, default_sink_name)
      PactlOut.new(
        [
          { marker: /Sink #/, property: :id },
          { marker: /Name:/, property: :name },
          { marker: /Description:/, property: :description }
        ]
      ).parse(out).each { |sink| sink[:default] = true if sink[:name] == default_sink_name }
    end

    def self.parse_inputs(out)
      PactlOut.new(
        [
          { marker: /Sink Input #/, property: :id }
        ]
      ).parse(out)
    end

    def self.parse_event(out_line)
      parts = out_line.split(' ')
      {
        type: parts[1].delete('\'').to_sym,
        object: parts[3].to_sym,
        id: parts[4].sub('#', '')
      }
    end

    def self.parse_default_sink(out)
      out.match(/^Default Sink: (.*?)\n/)[1]
    end

    def self.parse_modules(out)
      PactlOut.new(
        [
          { marker: /Module #/ },
          { marker: /Name:/, property: :name }
        ]
      ).parse(out)
    end

    def self.parse_sources(out)
      PactlOut.new(
        [
          { marker: /Source #/, property: :id },
          { marker: /Mute:/, property: :mute }
        ]
      ).parse(out).each { |source| source[:mute] = source[:mute] == 'yes' }
    end

    def self.read_name(line)
      read_property(line, 'Name:')
    end

    class PactlOut
      def initialize(fields)
        @fields = fields
      end

      def parse(string)
        results = []
        field_id = 0
        result = nil

        string.each_line do |line|
          field = @fields[field_id]
          next unless line =~ field[:marker]

          result = {} if field_id == 0
          update(result, line, field)

          field_id += 1
          next unless field_id == @fields.size

          results << result
          result = nil
          field_id = 0
        end

        results
      end

      def update(result, line, field)
        property = field[:property]
        result[property] = read_property(line, field[:marker]) if field[:property]
      end

      def read_property(line, marker)
        line.match(Regexp.new("#{marker}\\s*(.*?)\\s*$"))[1]
      end
    end
  end
end
