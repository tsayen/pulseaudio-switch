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
      puts sink_id
    end

    def sinks
      @pactl.sinks
    end
  end
end
