function __vpn_get_configs
    set -l configs

    for cfg in (string split " " (ls /etc/openvpn/client/*.conf))
        set -a configs (string replace -r '\.conf$' "" (basename $cfg))
    end

    echo $configs
end

function __vpn_get_state
    set -l config $argv[1]
    set -l active_state (systemctl is-active openvpn-client@$config.service)

    switch $active_state
        case inactive
            echo (set_color white)"*"(set_color normal)
        case failed
            echo (set_color magenta)"✘"(set_color normal)
        case active
            echo (set_color green)"✔"(set_color normal)
        case '*'
            echo (set_color yellow)"?"(set_color normal)
    end
end

function __vpn_print_usage
    set -l func $argv[1]
    echo "usage: $func ACTION [CONN]"
end

function __vpn_print_help
    echo "Manage VPN connections with openvpn-client@.service"
    echo ""
    echo "possible values for ACTION:"
    echo "  help            show this help message"
    echo "  list            list all configured connections"
    echo "  start CONN      start service for connection CONN"
    echo "  stop [CONN]     stop service for connection CONN"
    echo "  restart CONN    restart service for connection CONN"
    echo "  status [CONN]   show status of service for connection CONN"
end

function vpn -d "manage VPN connections with openvpn-client@.service"
    if test (count $argv) -lt 1
        __vpn_print_usage (status function) >&2
        echo "see '"(status function)" help' for more info" >&2
        return 1
    end

    if test (count $argv) -gt 2
        echo (set_color red)"Error:"(set_color normal)" Too many parameters" >&2
        __vpn_print_usage (status function) >&2
        echo "see '"(status function)" help' for more info" >&2
        return 1
    end

    set -l cmd $argv[1]
    switch $cmd
        case help
            __vpn_print_usage (status function)
            echo ""
            __vpn_print_help
            return 0
        case list
            echo "Configured connections:"
            for cfg in (string split " " (__vpn_get_configs))
                set -l state (__vpn_get_state $cfg)
                echo "  "(set_color blue)"[$state"(set_color blue)"]"(set_color normal)" $cfg"
            end
            return 0
        case start
        case stop
        case restart
        case status
        case logs
        case '*'
            echo "Unknown command: $cmd" >&2
            echo "see '"(status function)" help' for more info" >&2
            return 1
    end

    set -l cfg $argv[2]
    set -la configs (string split " " (__vpn_get_configs))

    if test -z $cfg
        echo (set_color red)"Error:"(set_color normal)" Missing parameter CONN"
        echo "see '"(status function)" help' for more info" >&2
        return 1
    end
    if not contains $cfg $configs
        echo (set_color red)"Error:"(set_color normal)" invalid connection configuration '$cfg'" >&2
        echo "see '"(status function)" list' to show available connections" >&2
        return 1
    end

    function __vpn_perform_action
        set -l action $argv[1]
        set -l cfg $argv[2]

        systemctl $action openvpn-client@$cfg.service
        set -l success $status

        if test $success -ne 0
            echo (set_color red)"Error:"(set_color normal)" Could not $action VPN service for connection '$cfg'.">&2
            echo "       See '"(status function)" status $cfg' for possible reasons" >&2
            return $success
        end
    end

    switch $cmd
        case start
            echo "Starting VPN connection $cfg..."
            __vpn_perform_action start $cfg || return $status
        case stop
            echo "Stopping VPN connection $cfg..."
            __vpn_perform_action stop $cfg || return $status
        case restart
            echo "Restarting VPN connection $cfg..."
            __vpn_perform_action restart $cfg || return $status
        case status
            systemctl status openvpn-client@$cfg.service
            return $status
        case logs
            journalctl -eb --unit openvpn-client@$cfg.service
            return $status
    end

    echo "Done"
end
