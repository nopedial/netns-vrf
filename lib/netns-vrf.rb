module VRFLite
  Directory = File.expand_path File.join File.dirname(__FILE__), '../' 
  require 'netns-vrf/ip.rb'
  require 'netns-vrf/route.rb'
  require 'netns-vrf/netns.rb'
  require 'netns-vrf/interface.rb'
end
