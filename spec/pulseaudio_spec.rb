require 'pulseaudio.rb'

RSpec.describe PulseAudioSwitch::PulseAudio do
  it 'should parse pactl sinks output' do
    sinks = PulseAudioSwitch::PulseAudio.parse_sinks(File.read('spec/resources/pactl-list-sinks.out'))

    expect(sinks).to eql([{
                           id: '0',
                           name: 'alsa_output.pci-0000_00_1b.0.analog-stereo',
                           description: 'Built-in Audio Analog Stereo'
                         }, {
                           id: '1',
                           name: 'rtp',
                           description: 'RTP Multicast'
                         }])
  end
end
