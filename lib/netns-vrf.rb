# netns-vrf - dirty linux netns wrapper library
#
# VRFLite::NetNs.(create|destroy)
# VRFLite::Interface.(add_to_vrf|del_from_vrf)
# VRFLite::IPaddr.(add_to_vrf|del_from_vrf|add_ip6_to_vrf|del_ip6_from_vrf)
# VRFLite::StaticRouting.(route_via_vrf|del_from_vrf|route_ip6_via_vrf|del_ip6_from_vrf)
#

module VRFLite

  class NetNs # provides: create / destroy / display on 'vrf_name'

    def initialize(vrf_name)
      @vrf_name = vrf_name
    end

    def create
      system("ip netns add #{@vrf_name}")
      system("ip netns exec #{@vrf_name} ip link set lo up") 
      return 0
    end

    def destroy
      system("ip netns delete #{@vrf_name}")
      return 0
    end
 
    def display
      if @vrf_name == nil or @vrf_name == "all"
      		vrf_array = []
      		network_name_spaces = Dir["/var/run/netns/*"]
      		network_name_spaces.each do |net_ns|
      			vrf_lite_path = net_ns.split "/"
     			vrf_lite_id = vrf_lite_path[4]
               		vrf_array << vrf_lite_id
                end
		return vrf_array[0..-1]
      else
		vrf_array = []
		network_name_spaces = Dir["/var/run/netns/#{@vrf_name}"]
		network_name_spaces.each do |net_ns|
			vrf_lite_path = net_ns.split "/"
			vrf_lite_id = vrf_lite_path[4]
			vrf_array << vrf_lite_id
		end
		return vrf_array
      end
    end

  end

  class Interface # provides: add_to_vrf / del_from_vrf for 'if_name' on 'vrf_name'

    def initialize(if_name, vrf_name)
      @if_name = if_name
      @vrf_name = vrf_name
    end

    def add_to_vrf
      dev_location = `cat /proc/net/dev | grep ':' | cut -d ':' -f 1 | grep #{@if_name} | head -n 1`.chop
      if dev_location != ''    
      		system("ip link set #{@if_name} netns #{@vrf_name}")
		system("ip netns exec #{@vrf_name} ip link set #{@if_name} up")
		return 0
      else
		return 1
      end
    end

    def del_from_vrf
      dev_location = `ip netns exec #{@vrf_name} cat /proc/net/dev | grep ':' | cut -d ':' -f 1 | grep #{@if_name} | head -n 1`.chop
      if dev_location != ''
		system("ip netns exec #{@vrf_name} ip link set #{@if_name} down")
		system("ip netns exec #{@vrf_name} ip link del #{@if_name}")
		return 0
       else
		return 1
       end
    end	

  end

  class IPaddr # provides: add_to_vrf / del_from_vrf for 'vrf_addr' on 'if_name' mapped to 'vrf_name'
    def initialize(if_name, vrf_name, vrf_addr)
       @if_name = if_name
       @vrf_name = vrf_name
       @vrf_addr = vrf_addr
    end

    def add_to_vrf
      system("ip netns exec #{@vrf_name} ip address add #{@vrf_addr} dev #{@if_name}")
      return 0
    end

    def del_from_vrf
      system("ip netns exec #{@vrf_name} ip address del #{@vrf_addr} dev #{@if_name}")
      return 0
    end

    def add_ip6_to_vrf
      system("ip netns exec #{@vrf_name} ip -6 address add #{@vrf_addr} dev #{@if_name}")
      return 0
    end
    
    def del_ip6_from_vrf
      system("ip netns exec #{@vrf_name} ip -6 address del #{@vrf_addr} dev #{@if_name}")
      return 0
    end

  end

  class StaticRoute # provides: route_via_vrf / del_from_vrf for 'vrf_rt_dst' via 'vrf_gw' on 'if_name' mapped to 'vrf_name'

    def initialize(if_name, vrf_name, vrf_gw, vrf_rt_dst)
      @if_name = if_name
      @vrf_name = vrf_name
      @vrf_gw = vrf_gw
      @vrf_rt_dst = vrf_rt_dst
    end

    def route_via_vrf
      system("ip netns exec #{@vrf_name} ip route add #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

    def del_from_vrf
      system("ip netns exec #{@vrf_name} ip route del #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

    def route_ip6_via_vrf
      system("ip netns exec #{@vrf_name} ip -6 route add #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

    def del_ip6_from_vrf
      system("ip netns exec #{@vrf_name} ip -6 route del #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

  end

end
