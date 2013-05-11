module VRFLite
  class NetNs # provides: build / destroy / display on NetNS #
    def initialize(vrf_name)
       @vrf_name = vrf_name
    end

    def build
       system("ip netns add #{@vrf_name}")
       system("ip netns exec #{@vrf_name} ip link set lo up") # initialize stack loopback #
       return 0
    end

    def destroy
       system("ip netns delete #{@vrf_name}")
       return 0
    end

    def display
       vrf_config = []
       if @vrf_name == nil || @vrf_name == "all"
          net_ns = Dir["/var/run/netns/*"]
       else
          net_ns = Dir["/var/run/netns/#{@vrf_name}"]
       end
       net_ns.each do |ns|
           vrf_path = net_ns.to_s.split '/'
	   vrf_id = vrf_path[4].chop.chop
           vrf_config << vrf_id
       end
       return vrf_config if @vrf_name != nil || @vrf_name == "all"
       return vrf_config[0..-1]
    end
  end
end             
          
