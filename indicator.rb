require "rubygems"
require "ruby-libappindicator"

ai = AppIndicator::AppIndicator.new("test", "multimedia-volume-control", AppIndicator::Category::HARDWARE);

ai.set_menu(Gtk::Menu.new)
ai.set_status(AppIndicator::Status::ACTIVE)

Gtk.main
