module PulseAudioSwitch
  class Model
    def initialize(pulse_audio)
      @sinks = {}
      @pulse_audio = pulse_audio
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
      @pulse_audio.sinks
    end
  end
end
