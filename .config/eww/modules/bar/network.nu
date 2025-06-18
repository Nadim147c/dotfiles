#!/usr/bin/nu

# Parse /proc/net/dev and extract interface stats
def parse-net-dev [] {
  cat /proc/net/dev
      | lines
      | where ($it | str contains ":")
      | parse -r '(?<iface>\w+):\s*(?<rx>\d+)\s+(?:\d+\s+){7}(?<tx>\d+)'
      | update rx {|row| $row.rx | into filesize }
      | update tx {|row| $row.tx | into filesize }
}

# Get stats before and after delay
mut before = parse-net-dev

while true {
    sleep 2sec
    let after = parse-net-dev
    if ($after | is-empty) {
        continue
    }

    let delta = $before | join $after iface iface
        | upsert drx {|it| ($it.rx_ - $it.rx) / 2 }
        | upsert dtx {|it| ($it.tx_ - $it.tx) / 2 }
        | select iface drx dtx
        | upsert change {|it| $it.drx + $it.dtx}
        | rename --column { iface: interface drx: down dtx: up }
        | sort-by change --reverse

    let speed = $delta
        | first
        | upsert down {|it| $it.down | into string | $"($in)/s"}
        | upsert up {|it| $it.up| into string | $"($in)/s" }
        | upsert change {|it| $it.change | into string | $"($in)/s" }
        | upsert wireless {|it| $"/sys/class/net/($it.interface)/wireless" | path exists }
        | upsert table { $delta | table --index false --theme psql | ansi strip | str trim --right }

    print ($speed | to json --raw)
    $before = $after
}
