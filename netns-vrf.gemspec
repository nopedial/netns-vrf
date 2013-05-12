Gem::Specification.new do |s|
  s.name              = 'netns-vrf'
  s.version           = '0.0.3'
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Samer Abdel-Hafez' ]
  s.email             = %w( sam@arahant.net )
  s.homepage          = 'http://github.com/nopedial/netns-vrf'
  s.summary           = 'quick and dirty linux netns wrapper'
  s.description       = 'linux vrf-lite command line wannabe'
  s.rubyforge_project = s.name
  s.files 	      = `ls lib/*/*`.split("\n")
  s.executables       = %w( netns-vrf )
  s.require_path      = 'lib'

end
