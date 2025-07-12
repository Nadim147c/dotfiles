#!/usr/bin/env nu

http get $"wttr.in/(cat ~/.config/.location)?0" | tail +3 | ansi strip
