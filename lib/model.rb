module AudioSwitch
  class Model
    MODULE_RTP_SEND = 'module-rtp-send'.freeze
    MODULE_NULL_SINK = 'module-null-sink'.freeze
    RTP = 'rtp'.freeze

    def initialize(pactl)
      @pactl = pactl
      pactl.subscribe { |event| handle(event) }
    end

    def watch(&block)
      @update = block
      @update.call
    end

    def select_sink(sink_id)
      @current_sink = sink_id
      @pactl.default_sink = sink_id
      @pactl.inputs.each do |input|
        @pactl.move_input(input[:id], sink_id)
      end
    end

    def sinks
      @pactl.sinks
    end

    def rtp_on?
      return false unless @pactl.modules.any? { |mod| mod[:name] == MODULE_RTP_SEND }
      return false unless @pactl.sinks.any? { |sink| sink[:name] == RTP }
      true
    end

    def rtp_on
      # see https://cgit.freedesktop.org/pulseaudio/paprefs/tree/src/paprefs.cc
      @pactl.load_module(MODULE_NULL_SINK, 'sink_name' => 'rtp',
                                           'format' => 's16be',
                                           'channels' => '2',
                                           'rate' => '44100',
                                           'sink_properties' => {
                                             'device.description' => 'RTP sender',
                                             'device.bus' => 'network',
                                             'device.icon_name' => 'network-server'
                                           })
      @pactl.load_module(MODULE_RTP_SEND, 'source' => 'rtp.monitor')
    end

    def rtp_off
      @pactl.unload_module(MODULE_RTP_SEND)
      @pactl.unload_module(MODULE_NULL_SINK)
    end

    private

    def handle(event)
      @update.call if event[:object] == :sink
    end
  end
end
