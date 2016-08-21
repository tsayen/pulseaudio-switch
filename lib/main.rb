#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require_relative 'pactl.rb'
require_relative 'model.rb'
require_relative 'ui.rb'

def main
  pactl = AudioSwitch::Pactl.new
  model = AudioSwitch::Model.new(pactl)
  ui = AudioSwitch::UI.new(model)
  ui.start
end

begin
  main
rescue Interrupt
  puts "\nexit"
end
