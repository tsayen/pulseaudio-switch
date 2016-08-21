require 'pactl.rb'
require 'rspec/wait'

Pactl = AudioSwitch::Pactl
describe Pactl do
  it 'should parse pactl sinks output' do
    sinks = Pactl.parse_sinks(File.read('spec/resources/pactl_list_sinks'),
                              'alsa_output.pci-0000_00_1b.0.analog-stereo')

    expect(sinks).to \
      eql([{
            id: '0',
            name: 'alsa_output.pci-0000_00_1b.0.analog-stereo',
            description: 'Built-in Audio Analog Stereo',
            default: true
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

  it 'should parse pactl stat' do
    default_sink = Pactl.parse_default_sink(File.read('spec/resources/pactl_stat'))

    expect(default_sink).to eql('alsa_output.pci-0000_00_1b.0.analog-stereo')
  end

  it 'should parse pactl modules' do
    modules = Pactl.parse_modules(File.read('spec/resources/pactl_list_modules'))

    expect(modules).to include(name: 'module-rtp-send')
  end

  it 'should parse pactl sources' do
    sources = Pactl.parse_sources(File.read('spec/resources/pactl_list_sources'))

    expect(sources).to eql([{ id: '1', mute: true }, { id: '110', mute: false }])
  end

  it 'should notify of events' do
    command = ["Event 'new' on sink-input '#72'",
               "Event 'change' on sink '#0'",
               "Event 'remove' on sink-input '#60'"]
              .map { |line| "echo #{line}" }
              .join('; ') + '; sleep 10s'

    pactl = Pactl.new
    events = []

    pactl.subscribe(command) do |event|
      events.push(event)
      pactl.dispose if events.size == 3
    end

    wait_for(events).to \
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

  it 'should format module options' do
    options1 = { 'name' => 'rtp', 'channels' => '2' }
    options2 = { 'name' => 'rtp', 'options' => { 'description' => 'RTP' } }

    expect(Pactl.format_module_opts(options1)).to eql('name=rtp channels=2')
    expect(Pactl.format_module_opts(options2)).to eql("name=rtp options=\\\"description=\\\'RTP\\\'\\\"")
  end
end
