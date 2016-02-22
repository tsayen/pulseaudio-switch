require 'ruby-libappindicator'
require 'gtk2'

class SwitchUi
    def initialize &on_toggle
        @icon = AppIndicator::AppIndicator.new('test', 'multimedia-volume-control', AppIndicator::Category::HARDWARE)
        @menu = Gtk::Menu.new
        @icon.set_menu(@menu)
        @icon.set_status(AppIndicator::Status::ACTIVE)

        switch = []

        network = Gtk::RadioMenuItem.new(switch, 'network')
        @menu.append(network)
        network.show
        switch.push(network)

        network.signal_connect('toggled', &on_toggle)

        local = Gtk::RadioMenuItem.new(switch, 'local')
        @menu.append(local)
        local.show
        local.set_active(false)
        switch.push(local)

        local.signal_connect('toggled', &on_toggle)
    end
end
