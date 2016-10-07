require 'audio_switch/model'

describe AudioSwitch::Model do
  it 'should set default sink' do
    # given
    inputs = [{ id: 0 }, { id: 1 }]
    pactl = instance_double('AudioSwitch::Pactl',
                            subscribe: nil,
                            inputs: inputs,
                            :default_sink= => nil,
                            move_input: nil)
    model = AudioSwitch::Model.new(pactl)
    # when
    model.select_sink(42)
    # then
    expect(pactl).to have_received(:default_sink=).with(42)
    expect(pactl).to have_received(:inputs).once
    expect(pactl).to have_received(:move_input).with(0, 42)
    expect(pactl).to have_received(:move_input).with(1, 42)
  end

  it 'should notify when callback added' do
    # given
    events = 0
    pactl = instance_double('AudioSwitch::Pactl', subscribe: nil)
    model = AudioSwitch::Model.new(pactl)
    # when
    model.watch { events += 1 }
    # then
    expect(events).to eql(1)
  end

  it 'should notify when sink or source event received' do
    # given
    events = -1
    event = nil
    pactl = instance_double('AudioSwitch::Pactl')
    allow(pactl).to receive(:subscribe) { |&block| event = block }
    model = AudioSwitch::Model.new(pactl)
    model.watch { events += 1 }
    # when
    event.call(type: :new, object: :sink, id: 1)
    event.call(type: :change, object: :sink, id: 1)
    event.call(type: :remove, object: :sink, id: 1)
    event.call(type: :new, object: :source, id: 1)
    event.call(type: :change, object: :source, id: 1)
    # then
    expect(events).to eql(5)
  end

  it 'should not notify when other events received' do
    # given
    events = -1
    event = nil
    pactl = instance_double('AudioSwitch::Pactl')
    allow(pactl).to receive(:subscribe) { |&block| event = block }
    model = AudioSwitch::Model.new(pactl)
    model.watch { events += 1 }
    # when
    event.call(type: :new, object: :'sink-input', id: 1)
    event.call(type: :change, object: :'sink-input', id: 1)
    event.call(type: :remove, object: :'sink-input', id: 1)
    # then
    expect(events).to eql(0)
  end

  it 'should tell whether rtp is on or off' do
    # given
    def model(modules, sinks)
      pactl = instance_double('AudioSwitch::Pactl',
                              subscribe: nil,
                              modules: modules,
                              sinks: sinks)
      AudioSwitch::Model.new(pactl)
    end
    # then
    expect(model(
      [{ name: 'module-rtp-send' }],
      [{ name: 'rtp' }]
    ).rtp_on?).to be_truthy

    expect(model(
      [],
      [{ name: 'rtp' }]
    ).rtp_on?).to be_falsey

    expect(model(
      [{ name: 'module-rtp-send' }],
      []
    ).rtp_on?).to be_falsey

    expect(model(
      [{ name: 'module-stream-restore' }],
      [{ name: 'rtp' }]
    ).rtp_on?).to be_falsey
  end

  it 'should turn rtp on' do
    # given
    pactl = instance_double('AudioSwitch::Pactl',
                            subscribe: nil,
                            sinks: [{ id: 1, name: 'rtp' },
                                    { id: 2, name: 'analog', default: true }],
                            inputs: [],
                            load_module: nil,
                            :'default_sink=' => nil,
                            sources: [{ id: 10 }],
                            mute_source: nil)
    model = AudioSwitch::Model.new(pactl)
    # when
    model.rtp_on
    # then
    expect(pactl).to have_received(:load_module).with('module-rtp-send', any_args)
    expect(pactl).to have_received(:load_module).with('module-null-sink', any_args)
    expect(pactl).to have_received(:default_sink=).with(2)
    expect(pactl).to have_received(:mute_source).with(10)
  end

  it 'should turn rtp off' do
    # given
    pactl = instance_double('AudioSwitch::Pactl',
                            subscribe: nil,
                            unload_module: nil)
    model = AudioSwitch::Model.new(pactl)
    # when
    model.rtp_off
    # then
    expect(pactl).to have_received(:unload_module).with('module-rtp-send')
    expect(pactl).to have_received(:unload_module).with('module-null-sink')
  end

  it 'should mute sources' do
    # given
    pactl = instance_double('AudioSwitch::Pactl',
                            subscribe: nil,
                            mute_source: nil,
                            sources: [{ id: '1' }, { id: '2' }, { id: '3', name: 'rtp.monitor' }])
    model = AudioSwitch::Model.new(pactl)
    # when
    model.mute_sources
    # then
    expect(pactl).to have_received(:mute_source).with('1')
    expect(pactl).to have_received(:mute_source).with('2')
  end

  it 'should unmute sources' do
    # given
    pactl = instance_double('AudioSwitch::Pactl',
                            subscribe: nil,
                            unmute_source: nil,
                            sources: [{ id: '1' }, { id: '2' }, { id: '3', name: 'rtp.monitor' }])
    model = AudioSwitch::Model.new(pactl)
    # when
    model.unmute_sources
    # then
    expect(pactl).to have_received(:unmute_source).with('1')
    expect(pactl).to have_received(:unmute_source).with('2')
  end

  it 'should tell whether sources are mute' do
    # given
    def model(sources)
      pactl = instance_double('AudioSwitch::Pactl',
                              subscribe: nil,
                              sources: sources)
      AudioSwitch::Model.new(pactl)
    end
    # then
    expect(model(
      [{ mute: true },
       { mute: true }]
    ).sources_mute?).to be_truthy

    expect(model(
      [{ mute: false },
       { mute: true }]
    ).sources_mute?).to be_falsey

    expect(model(
      [{ mute: false },
       { mute: false }]
    ).sources_mute?).to be_falsey

    expect(model(
      [{ name: 'rtp.monitor', mute: false },
       { mute: true },
       { mute: true }]
    ).sources_mute?).to be_truthy

    expect(model(
      []
    ).sources_mute?).to be_truthy
  end
end
