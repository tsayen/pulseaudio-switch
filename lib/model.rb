module AudioSwitch
  class Model
    def initialize(pactl)
      @sinks = {}
      @pactl = pactl
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
      @pactl.sinks
    end
  end
end
