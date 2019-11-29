function __fish_vpn_complete_configs
    for cfg in (string split " " (ls /etc/openvpn/client/*.conf))
        string replace -r '\.conf$' "" (basename $cfg)
    end
end

function __fish_vpn_complete_only_active
    for cfg in (__fish_vpn_complete_configs)
        systemctl is-active openvpn-client@$cfg.service 2>&1 >/dev/null
        if test $status -eq 0
            echo $cfg
        end
    end
end

function __fish_vpn_complete_only_inactive
    for cfg in (__fish_vpn_complete_configs)
        systemctl is-active openvpn-client@$cfg.service 2>&1 >/dev/null
        if test $status -ne 0
            echo $cfg
        end
    end
end

set -l vpn_commands help list start stop restart status logs

# basic commands
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a help -d 'print help about subcommands'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a list -d 'list available connections'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a start -d 'start connection service'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a stop -d 'stop connection service'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a restart -d 'restart connection service'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a status -d 'show connection service status'
complete -f -c vpn -n "not __fish_seen_subcommand_from $vpn_commands" -a logs -d 'show full logs of connection service'

# all configs for restart, status, logs
complete -f -c vpn -n "__fish_seen_subcommand_from restart status logs; and not __fish_seen_subcommand_from (__fish_vpn_complete_configs)" -a "(__fish_vpn_complete_configs)"

# only failed or stopped connections for start
complete -f -c vpn -n "__fish_seen_subcommand_from start; and not __fish_seen_subcommand_from (__fish_vpn_complete_configs)" -a "(__fish_vpn_complete_only_inactive)"

# only running connections for stop
complete -f -c vpn -n "__fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from (__fish_vpn_complete_configs)" -a "(__fish_vpn_complete_only_active)"

# no further completions after done
complete -f -c vpn -n "__fish_seen_subcommand_from help list"
complete -f -c vpn -n "__fish_seen_subcommand_from start stop restart status logs; and __fish_seen_subcommand_from (__fish_vpn_complete_configs)"

