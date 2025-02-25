#!/usr/bin/env nu

def main [
    --kill # Kill hyprsunset
] {
    if $kill {
        killall hyprsunset
        return
    }

    let day = (24 * 3600)
    let start_of_day = (5 * 3600) # Day starts at 6 AM
    let 6pm = (13 * 3600)         # 6 PM since 5 AM
    let 10pm = (17 * 3600)        # 10 PM since 5 AM

    mut last_temp = 0

    loop {
        let hour = (date now | format date "%H" | into int | $in * 3600)
        let min = (date now | format date "%M" | into int | $in * 60)
        let sec = (date now | format date "%S" | into int)
        let seconds = $hour + $min + $sec

        let current_time = if $seconds > $start_of_day { $seconds - $start_of_day } else { $day - $start_of_day }

        mut temp = 8000  # Default starting temp

        if $current_time >= $6pm and $current_time <= $10pm {
            let progress = ($current_time - $6pm) / ($10pm - $6pm)
            $temp = (8000 - ($progress * (8000 - 5000))) | into int
            print $"Adjusting temp: ($temp)K"
        } else if $current_time > $10pm {
            $temp = 5000
            print $"Adjusting temp: ($temp)K"
        } else {
            print $"Temp remains default: ($temp)K"
        }

        if $last_temp != $temp {
            ps --long | where name == "hyprsunset" | get pid | if ($in | length) > 7 {^kill ...$in}
            hyprctl dispatch exec -- hyprsunset -t $temp
            $last_temp = $temp
        }

        sleep 10min
    }
}
