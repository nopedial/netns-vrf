module VRFLite
  class IP
    def initialize(ip_addr, if_name, vrf_name)
        @if_name = if_name
        @vrf_name = vrf_name
        @ip_addr = ip_addr
    end
    def add_to_vrf
      system("ip netns exec #{@vrf_name} ip address add #{@ip_addr} dev #{@if_name}")
      return 0
    end
    def del_from_vrf
      system("ip netns exec #{@vrf_name} ip address del #{@ip_addr} dev #{@if_name}")
      return 0
    end
    def add_ip6_to_vrf
      system("ip netns exec #{@vrf_name} ip -6 address add #{@ip_addr} dev #{@if_name}")
      return 0
    end
    def del_ip6_from_vrf
      system("ip netns exec #{@vrf_name} ip -6 address del #{@ip_addr} dev #{@if_name}")
      return 0
    end
  end
end
