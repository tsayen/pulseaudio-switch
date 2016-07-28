require 'model.rb'

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

  it 'should notify when sink event received' do
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
    # then
    expect(events).to eql(3)
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
end
