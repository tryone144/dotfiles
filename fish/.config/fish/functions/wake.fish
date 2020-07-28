# wakeonlan helper
function __check_host -d "check if host is reachable via ICMP ping"
    set -l ipaddr $argv[1]
    ping -W 1 -c 1 "$ipaddr" &>/dev/null
end

function __wol_hostmac -d "send magic WOL packet and wait until the host is reachable"
    set -l mac $argv[1]
    set -l ipaddr $argv[2]

    echo "Wake up $mac ..."
    for i in (seq 0 4)
        wol -i 255.255.255.255 -p 9 -w 50 "$mac"
        sleep 0.2
    end

    echo "Wait for $ipaddr ..."
    while not __check_host "$ipaddr"
        sleep 4
    end

    echo "$ipaddr has successfully woken up"
end

function wake -d "wakeup host via Wake-on-LAN"
    set -l host $argv[1]

     switch $host
        case "fileserver"
            __wol_hostmac 00:1c:c0:b4:d2:81 192.168.110.1
        case "sachnix"
            __wol_hostmac 90:2b:34:ad:36:73 192.168.110.40
        case "mrxeon"
            __wol_hostmac 00:19:99:9d:60:9e 192.168.110.46
        case "verleihnix"
            __wol_hostmac 00:19:99:30:71:33 192.168.110.68
        case "airfix"
            __wol_hostmac 00:19:db:67:91:14 192.168.110.69
        case "*"
            echo "ERROR: Unknown host '$host'" >&2
            return 1
    end
end
