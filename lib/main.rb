#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require_relative 'ui.rb'
require_relative 'model.rb'
require_relative 'pactl.rb'

model = AudioSwitch::Model.new(AudioSwitch::Pactl.new)
AudioSwitch::UI.new(model)

Gtk.main
