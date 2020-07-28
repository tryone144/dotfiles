set -l hosts fileserver sachnix mrxeon verleihnix airfix

for host in $hosts
    complete -f -c wol -n "not __fish_seen_subcommand_from $hosts" -a $host -d "Wake up '$host' via Wake-on-LAN"
end

complete -f -c wol -n "__fish_seen_subcommand_from $hosts"
