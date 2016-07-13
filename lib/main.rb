#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require_relative 'ui.rb'
require_relative 'model.rb'
require_relative 'pulseaudio.rb'

model = PulseAudioSwitch::Model.new(PulseAudioSwitch::PulseAudio.new)
PulseAudioSwitch::UI.new(model)

Gtk.main
