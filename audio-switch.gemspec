# coding: utf-8
require File.expand_path('../lib/sleepr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'ubuntu-audio-switch'
  gem.version       = Ubuntu::Audio::Switch::VERSION
  gem.authors       = ['tsayen']
  gem.email         = ['anatoly.sayenko@gmail.com']
  gem.summary       = 'Audio sink switch for PulseAudio'
  gem.description   = 'Ubuntu system tray applet that lets you select audio sink, control RTP sender and mic. Depends on PulseAudio'
  gem.homepage      = 'https://github.com/tsayen/audio-switch'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|vendor)/}) }
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.11'
  gem.add_development_dependency 'rake', '~> 10.0'
end
