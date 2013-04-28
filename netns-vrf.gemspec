Gem::Specification.new do |s|
  s.name              = 'netns-vrf'
  s.version           = '0.0.0'
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Samer Abdel-Hafez' ]
  s.email             = %w( sam@arahant.net )
  s.homepage          = 'http://github.com/nopedial/netns-vrf'
  s.summary           = 'quick and dirty linux netns wrapper'
  s.description       = 'linux vrf-lite command line wannabe'
  s.rubyforge_project = s.name
  s.files             = ["lib/netns-vrf.rb"]
  s.executables       = %w( netns-vrf )
  s.require_path      = 'lib'

end
