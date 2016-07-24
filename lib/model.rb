module AudioSwitch
  class Model
    def initialize(pactl)
      @pactl = pactl
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
  end
end
