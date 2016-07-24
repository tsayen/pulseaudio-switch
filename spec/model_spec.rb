require 'model.rb'

describe AudioSwitch::Model do
  xit 'should get sinks from pulseaudio' do
    # given
    sinks = [{ id: 'sink0', title: 'Sink 0', active: false },
             { id: 'sink1', title: 'Sink 1', active: true }]
    pactl = instance_double('AudioSwitch::Pactl',
                            sinks: sinks)
    # when
    model = AudioSwitch::Model.new(pactl)
    # then
    expect(pactl).to have_received(:sinks).once
    expect(model.sinks).to equal(sinks)
  end

  it 'should set default sink' do
    # given
    inputs = [{ id: 0 }, { id: 1 }]
    pactl = instance_double('AudioSwitch::Pactl',
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
end
