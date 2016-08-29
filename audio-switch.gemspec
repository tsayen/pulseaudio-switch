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

  gem.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|vendor)/}) }
  gem.bindir = 'bin'
  gem.executables = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency 'gtk2'
  gem.add_dependency 'ruby-libappindicator'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-wait'
  gem.add_development_dependency 'rubocop'
end
