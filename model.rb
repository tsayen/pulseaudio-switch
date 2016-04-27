class SwitchModel
    def initialize
        @sinks = {}
    en

    def enable
        read_sinks.each do |sink|
            add_sink sink
            puts 'adding sink ' + sink.inspect
        end
    end

    def when_sink_added(&block)
        @sink_added = block
        @sinks.each_value do |sink|
            @sink_added.call sink
        end
    end

    def when_sink_selected(&block)
        @sink_selected = block
    end

    private

    def add_sink(sink)
        @sinks[sink.id] = sink
        @sink_added.call(sink) if @sink_added
    end

    def select_sink(sink)
        @current_sink = sink
        puts sink.id
    end

    def read_sinks
        lines = `pactl list sinks | grep -e 'Sink #' -e 'Name' -e 'Description'`.lines
        sinks = []
        while lines.size > 0
            number = lines.shift.sub(/Sink/, '').strip
            id = lines.shift.sub(/Name:/, '').strip
            title = lines.shift.sub(/Description:/, '').strip
            sinks.push Sink.new(id, number, title)
        end
        sinks
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
