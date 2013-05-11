module VRFLite
  class Route
    def initialize(vrf_rt_dst, vrf_gw, if_name, vrf_name)
      @if_name = if_name
      @vrf_name = vrf_name
      @vrf_gw = vrf_gw
      @vrf_rt_dst = vrf_rt_dst
    end
    def add_to_vrf_inet
      system("ip netns exec #{@vrf_name} ip route add #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end
    def del_from_vrf_inet
      system("ip netns exec #{@vrf_name} ip route del #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

    def add_to_vrf_inet6
      system("ip netns exec #{@vrf_name} ip -6 route add #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

    def del_from_vrf_inet6
      system("ip netns exec #{@vrf_name} ip -6 route del #{@vrf_rt_dst} via #{@vrf_gw} dev #{@if_name}")
      return 0
    end

  end

end
