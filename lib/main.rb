#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require_relative 'ui.rb'
require_relative 'model.rb'
require_relative 'pactl.rb'

pactl = AudioSwitch::Pactl.new
model = AudioSwitch::Model.new(pactl)
ui = AudioSwitch::UI.new(model)

ui.show
