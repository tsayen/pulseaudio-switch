require 'gtk2'
require 'ruby-libappindicator'

module AudioSwitch
  class UI
    def initialize(model)
      @model = model
      @menu = Gtk::Menu.new
      @items = []
    end

    def start
      add_to_tray
      subscribe
      Gtk.main
    end

    private

    def add_to_tray
      indicator = AppIndicator::AppIndicator.new(
        self.class.name,
        'multimedia-volume-control',
        AppIndicator::Category::HARDWARE
      )
      indicator.set_menu(@menu)
      indicator.set_status(AppIndicator::Status::ACTIVE)
    end

    def subscribe
      @model.watch { draw(@model.sinks) }
    end

    def draw(sinks)
      clear
      sinks.each { |sink| add new_item(sink) }
      add new_separator
      add new_rtp_toggle
      add new_mute_toggle
    end

    def add(item)
      @menu.append item
      @items.push item
      item.show
    end

    def new_item(sink)
      item = Gtk::RadioMenuItem.new(@items, sink[:description])
      item.signal_connect('toggled') do
        @model.select_sink(sink[:id]) if item.active?
      end
      item.set_active(sink[:default])
      item
    end

    def new_rtp_toggle
      toggle = Gtk::CheckMenuItem.new('Enable RTP')
      toggle.active = @model.rtp_on?
      toggle.signal_connect('toggled') do
        if toggle.active?
          @model.rtp_on
        else
          @model.rtp_off
        end
      end
      toggle
    end

    def new_mute_toggle
      toggle = Gtk::CheckMenuItem.new('Mute Inputs')
      toggle.active = @model.sources_mute?
      toggle.sensitive = !@model.rtp_on?
      toggle.signal_connect('toggled') do
        if toggle.active?
          @model.mute_sources
        else
          @model.unmute_sources
        end
      end
      toggle
    end

    def new_separator
      Gtk::SeparatorMenuItem.new
    end

    def clear
      @menu.remove(@items.pop) until @items.empty?
    end
  end
end
