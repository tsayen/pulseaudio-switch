require 'ruby-libappindicator'
require 'gtk2'

module PulseAudioSwitch
  class UI
    def initialize(model)
      @model = model
      @menu = Gtk::Menu.new
      @group = []
      add_to_tray
      subscribe
    end

    private

    def add_to_tray
      indicator =
        AppIndicator::AppIndicator.new(self.class.name, 'multimedia-volume-control', AppIndicator::Category::HARDWARE)
      indicator.set_menu @menu
      indicator.set_status AppIndicator::Status::ACTIVE
    end

    def subscribe
      @model.watch { refresh(model.sinks) }
    end

    def refresh(sinks)
      clear
      sinks.each { |sink| add new_item(sink) }
    end

    def add(item)
      @menu.append item
      @group.push item
      item.show
    end

    def new_item(sink)
      item = Gtk::RadioMenuItem.new(@group, sink[:title])
      item.signal_connect('toggled') do
        select(sink[:id]) if item.active?
      end
      item.set_active(sink[:active])
      item
    end

    def select(sink_id)
      @model.select_sink sink_id
    end

    def clear
      @menu.remove(@group.pop) until @group.empty?
    end
  end
end
