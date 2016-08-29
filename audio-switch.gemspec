require_relative 'lib/audio_switch/version'

Gem::Specification.new do |gem|
  gem.name = 'audio_switch'
  gem.version = AudioSwitch::VERSION
  gem.authors = ['Anatolii Saienko']
  gem.email = ['anatoly.sayenko@gmail.com']
  gem.summary = 'Sink switch for PulseAudio'
  gem.description = 'Ubuntu indicator that lets you switch audio sinks, toggle RTP sender and mic. Depends on PulseAudio'
  gem.homepage = 'https://github.com/tsayen/audio-switch'
  gem.license = 'MIT'

  gem.required_ruby_version = '>= 2.3'

  gem.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  gem.bindir = 'bin'
  gem.executables << 'audio_switch'
  gem.require_paths = ['lib']

  gem.add_dependency 'gtk2', '3.0.8'
  gem.add_dependency 'ruby-libappindicator', '0.1.5'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-wait'
end
