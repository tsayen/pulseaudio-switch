require 'model.rb'

describe AudioSwitch::Model do
  it 'should get sinks from pulseaudio' do
    # given
    sinks = [{ id: 'sink0', title: 'Sink 0', active: false },
             { id: 'sink1', title: 'Sink 1', active: true }]
    pactl = instance_double('AudioSwitch::Pactl', sinks: sinks)
    model = AudioSwitch::Model.new(pactl)
    # then
    expect(pactl).to receive(:sinks).once
    expect(model.sinks).to equal(sinks)
  end
end
