sinks = `pactl list short sinks`
sinks.each_line do |line|
    puts line
end
