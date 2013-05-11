module VRFLite
  class Interface
    def initialize(if_name, vrf_name)
       @if_name = if_name
       @vrf_name = vrf_name
    end
    def add_to_vrf
        dev_file = File.open("/proc/net/dev", "r")
        dev_file.each do |dev|
          if dev =~ /#{@if_name}:/ # check if the interface is in default vrf before pushing it to vrf #
             system("ip link set #{@if_name} netns #{@vrf_name}")
             system("ip netns exec #{@vrf_name} ip link set #{@if_name} up")
             @lock = 0
          else
             @lock = 1 # device is not in default netns #
          end
        end
        return @lock.to_i
    end
    def del_from_vrf
      dev_location = `ip netns exec #{@vrf_name} cat /proc/net/dev | grep ':' | cut -d ':' -f 1 | grep #{@if_name} | head -n 1`.chop # got to find a way to lookup the dev file of the netns #
      if dev_location != ''
         system("ip netns exec #{@vrf_name} ip link set #{@if_name} down")
         system("ip netns exec #{@vrf_name} ip link del #{@if_name}")
         return 0
      else
         return 1 # device is not in vrf #
      end
    end
  end
end

