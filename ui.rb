require 'ruby-libappindicator'
require 'gtk2'

class SwitchUi
  def initialize(model)
    @icon = AppIndicator::AppIndicator.new('test', 'multimedia-volume-control', AppIndicator::Category::HARDWARE)
    @menu = Gtk::Menu.new
    @group = []
    @icon.set_menu(@menu)
    @icon.set_status(AppIndicator::Status::ACTIVE)
    @item_by_sink_id = {}
    @model = model
  end

  def start
    @model.when_sink_added do |sink|
      menu_item = Gtk::RadioMenuItem.new(@group, sink.title)
      @menu.append(menu_item)
      @group.push(menu_item)
      @item_by_sink_id[sink.id] = menu_item
      menu_item.signal_connect('toggled') do
        model.select_sink(sink) if menu_item.active?
      end
      menu_item.show
    end

    @model.when_sink_selected do |sink|
      @item_by_sink_id[sink.id].set_active(true)
    end

    @model.enable

    Gtk.main
  end
end
