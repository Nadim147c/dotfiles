#!/usr/bin/env nu

ls ~/Pictures/Wallpapers/ --mime-type | where type starts-with image | get name | sort | to json --raw
