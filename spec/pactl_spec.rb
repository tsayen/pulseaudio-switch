require 'pactl.rb'

Pactl = AudioSwitch::Pactl
describe Pactl do
  it 'should parse pactl sinks output' do
    sinks = Pactl.parse_sinks(File.read('spec/resources/pactl_list_sinks'))

    expect(sinks).to \
      eql([{
            id: '#0',
            name: 'alsa_output.pci-0000_00_1b.0.analog-stereo',
            description: 'Built-in Audio Analog Stereo'
          }, {
            id: '#1',
            name: 'rtp',
            description: 'RTP Multicast'
          }])
  end

  describe 'pactl events' do
    it 'should parse events' do
      events = [
        "Event 'new' on sink-input #72",
        "Event 'change' on sink #0",
        "Event 'remove' on sink-input #60"
      ].map do |line|
        Pactl.parse_event(line)
      end

      expect(events).to \
        eql([{
              type:  :new,
              object: :'sink-input',
              id: '#72'
            }, {
              type:  :change,
              object: :sink,
              id: '#0'
            }, {
              type:  :remove,
              object: :'sink-input',
              id: '#60'
            }])
    end
  end
end
