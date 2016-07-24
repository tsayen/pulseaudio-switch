require 'pactl.rb'

Pactl = AudioSwitch::Pactl
describe Pactl do
  it 'should parse pactl sinks output' do
    sinks = Pactl.parse_sinks(File.read('spec/resources/pactl_list_sinks'))

    expect(sinks).to \
      eql([{
            id: '0',
            name: 'alsa_output.pci-0000_00_1b.0.analog-stereo',
            description: 'Built-in Audio Analog Stereo'
          }, {
            id: '1',
            name: 'rtp',
            description: 'RTP Multicast'
          }])
  end

  it 'should parse pactl inputs output' do
    inputs = Pactl.parse_inputs(File.read('spec/resources/pactl_list_inputs'))

    expect(inputs).to eql([{ id: '100' }, { id: '104' }])
  end

  it 'should notify of events' do
    command = ["Event 'new' on sink-input \"#72\"",
               "Event 'change' on sink \"#0\"",
               "Event 'remove' on sink-input \"#60\""]
              .map { |line| "echo #{line}" }
              .join('; ') + '; sleep 10s'

    pactl = Pactl.new
    events = []

    pactl.subscribe(command) do |event|
      events.push(event)
      pactl.dispose if events.size == 3
    end

    expect(events).to \
      eql([{
            type:  :new,
            object: :'sink-input',
            id: '72'
          }, {
            type:  :change,
            object: :sink,
            id: '0'
          }, {
            type:  :remove,
            object: :'sink-input',
            id: '60'
          }])
  end
end
