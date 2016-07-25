module AudioSwitch
  class Model
    def initialize(pactl)
      @pactl = pactl
      Thread.start do
        pactl.subscribe { |event| handle(event) }
      end
    end

    def watch(&block)
      @update = block
      @update.call
    end

    def select_sink(sink_id)
      puts sink_id
      @current_sink = sink_id
      @pactl.default_sink = sink_id
      @pactl.inputs.each do |input|
        @pactl.move_input(input[:id], sink_id)
      end
    end

    def sinks
      @pactl.sinks
    end

    private

    def handle(event)
      @update.call if event[:object] == :sink
    end
  end
end
