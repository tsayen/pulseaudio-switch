require 'ruby-libappindicator'

tray = AppIndicator::AppIndicator.new('test', 'multimedia-volume-control', AppIndicator::Category::HARDWARE)
group = []
menu = Gtk::Menu.new
network = Gtk::RadioMenuItem.new(group, "network")
menu.append(network)
network.show
group.push(network)
local = Gtk::RadioMenuItem.new(group, "local")
menu.append(local)
local.show
local.set_active(false)
group.push(local)

tray.set_menu(menu)
tray.set_status(AppIndicator::Status::ACTIVE)

Gtk.main
