class SwitchModel
    def initialize
        @sinks = {}
    end

    def when_sink_added &block
        @sink_added = block
    end

    def add_sink(sink)
        @sinks[sink.id] = sink
        @sink_added.call(sink)
    end

    def select_sink(sink)
        @current_sink = sink
        puts sink.id
    end

    def when_sink_selected &block
        @sink_selected = block
    end
end

class Sink
    attr_reader :id, :number, :title

    def initialize(id, number, title)
        @id = id
        @number = number
        @title = title
    end
end
