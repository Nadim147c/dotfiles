let available_countries = ["AF:Afghanistan" "AL:Albania" "DZ:Algeria" "AD:Andorra" "AO:Angola" "AG:Antigua and Barbuda" "AR:Argentina" "AM:Armenia" "AU:Australia" "AT:Austria" "AZ:Azerbaijan" "BS:Bahamas" "BH:Bahrain" "BD:Bangladesh" "BB:Barbados" "BY:Belarus" "BE:Belgium" "BZ:Belize" "BJ:Benin" "BT:Bhutan" "BO:Bolivia" "BA:Bosnia and Herzegovina" "BW:Botswana" "BR:Brazil" "BN:Brunei" "BG:Bulgaria" "BF:Burkina Faso" "BI:Burundi" "CV:Cabo Verde" "KH:Cambodia" "CM:Cameroon" "CA:Canada" "CF:Central African Republic" "TD:Chad" "CL:Chile" "CN:China" "CO:Colombia" "KM:Comoros" "CD:Congo, Democratic Republic of the" "CG:Congo, Republic of the" "CR:Costa Rica" "HR:Croatia" "CU:Cuba" "CY:Cyprus" "CZ:Czech Republic" "DK:Denmark" "DJ:Djibouti" "DM:Dominica" "DO:Dominican Republic" "EC:Ecuador" "EG:Egypt" "SV:El Salvador" "GQ:Equatorial Guinea" "ER:Eritrea" "EE:Estonia" "SZ:Eswatini" "ET:Ethiopia" "FJ:Fiji" "FI:Finland" "FR:France" "GA:Gabon" "GM:Gambia" "GE:Georgia" "DE:Germany" "GH:Ghana" "GR:Greece" "GD:Grenada" "GT:Guatemala" "GN:Guinea" "GW:Guinea-Bissau" "GY:Guyana" "HT:Haiti" "HN:Honduras" "HU:Hungary" "IS:Iceland" "IN:India" "ID:Indonesia" "IR:Iran" "IQ:Iraq" "IE:Ireland" "IL:Israel" "IT:Italy" "JM:Jamaica" "JP:Japan" "JO:Jordan" "KZ:Kazakhstan" "KE:Kenya" "KI:Kiribati" "KP:Korea, North" "KR:Korea, South" "XK:Kosovo" "KW:Kuwait" "KG:Kyrgyzstan" "LA:Laos" "LV:Latvia" "LB:Lebanon" "LS:Lesotho" "LR:Liberia" "LY:Libya" "LI:Liechtenstein" "LT:Lithuania" "LU:Luxembourg" "MG:Madagascar" "MW:Malawi" "MY:Malaysia" "MV:Maldives" "ML:Mali" "MT:Malta" "MH:Marshall Islands" "MR:Mauritania" "MU:Mauritius" "MX:Mexico" "FM:Micronesia" "MD:Moldova" "MC:Monaco" "MN:Mongolia" "ME:Montenegro" "MA:Morocco" "MZ:Mozambique" "MM:Myanmar" "NA:Namibia" "NR:Nauru" "NP:Nepal" "NL:Netherlands" "NZ:New Zealand" "NI:Nicaragua" "NE:Niger" "NG:Nigeria" "MK:North Macedonia" "NO:Norway" "OM:Oman" "PK:Pakistan" "PW:Palau" "PA:Panama" "PG:Papua New Guinea" "PY:Paraguay" "PE:Peru" "PH:Philippines" "PL:Poland" "PT:Portugal" "QA:Qatar" "RO:Romania" "RU:Russia" "RW:Rwanda" "WS:Samoa" "SM:San Marino" "ST:Sao Tome and Principe" "SA:Saudi Arabia" "SN:Senegal" "RS:Serbia" "SC:Seychelles" "SL:Sierra Leone" "SG:Singapore" "SK:Slovakia" "SI:Slovenia" "SB:Solomon Islands" "SO:Somalia" "ZA:South Africa" "SS:South Sudan" "ES:Spain" "LK:Sri Lanka" "SD:Sudan" "SR:Suriname" "SE:Sweden" "CH:Switzerland" "SY:Syria" "TW:Taiwan" "TJ:Tajikistan" "TZ:Tanzania" "TH:Thailand" "TL:Timor-Leste" "TR:Turkey" "TM:Turkmenistan" "TV:Tuvalu" "UG:Uganda" "UA:Ukraine" "AE:United Arab Emirates" "GB:United Kingdom" "US:United States" "UY:Uruguay" "UZ:Uzbekistan" "VU:Vanuatu" "VA:Vatican City" "VE:Venezuela" "VN:Vietnam" "YE:Yemen" "ZM:Zambia" "ZW:Zimbabwe"]

def pacman_pkgs [] {
    let cache = '/tmp/pacman-pkgs'
    if ($cache | path exists) {
        cat $cache | lines -s
    } else {
        let comp = paru -Pc | lines | split column " " "pkg" | get pkg
        $comp | to text | save -f $cache
        $comp
    }
}

def pacman_installed_pkgs [] {
    pacman -Qq | lines
}

# Installs the specified packages using pacman, but only if they are not already installed.
def "pac add" [
    ...pkgs: string@pacman_pkgs # List of packages to install
]: nothing -> nothing {
    paru -S --needed ...$pkgs
}

# Installs the specified packages using pacman without checking if they are already installed.
def "pac i" [
    ...pkgs: string@pacman_pkgs # List of packages to install
]: nothing -> nothing {
    paru -S ...$pkgs
}

# Installs the specified packages using pacman without checking if they are already installed.
def "pac install" [
    ...pkgs: string@pacman_pkgs # List of packages to install
]: nothing -> nothing {
    paru -S ...$pkgs
}

# Show arch linux news from homepage
def "pac news" []: nothing -> nothing {
    paru -Pw
}

# Finds the package that owns the specified files.
def "pac own" [
    ...files: string@pacman_pkgs # List of files to check
]: nothing -> nothing {
    pacman -Qo ...$files
}

# Removes the specified installed packages and their unused dependencies.
def "pac rm" [
    ...pkgs: string@pacman_installed_pkgs # List of packages to remove
]: nothing -> nothing {
    sudo pacman -Rs ...$pkgs
}

# Removes the specified installed packages and their unused dependencies.
def "pac remove" [
    ...pkgs: string@pacman_installed_pkgs # List of packages to remove
]: nothing -> nothing {
    sudo pacman -Rs ...$pkgs
}

# Removes the specified packages and their dependencies before upgrading.
def "pac upg" [
    --interactive(-i) # Select packages with fzf
    ...pkgs: string@pacman_pkgs # List of packages to install
]: nothing -> nothing {
    paru -Syu ...$pkgs
}

# Removes the specified packages and their dependencies before upgrading.
def "pac upgrade" [
    --interactive(-i) # Select packages with fzf
    ...pkgs: string@pacman_pkgs # List of packages to install
]: nothing -> nothing {
    paru -Syu ...$pkgs
}

# Lists all installed packages with an interactive fuzzy search interface.
def "pac list" []: nothing -> nothing {
    if (which fzf | length) == 0 {
        error make --unspanned { msg: "fzf command isn't isntalled." }
    }

    pacman -Qq | fzf --preview 'pacman -Qil {}' --bind 'enter:execute(pacman -Qil {} | less)'
}

# Searches available packages with an interactive fuzzy search interface, optionally filtered by a search term.
def "pac search" [
    pkg?: string@pacman_pkgs # Name of the package to search
]: nothing -> nothing {
    if (which fzf | length) == 0 {
        error make --unspanned { msg: "fzf command isn't isntalled." }
    }

    if $pkg != null {
        pacman -Slq | grep $pkg | fzf --preview 'pacman -Si {}' --bind 'enter:execute(pacman -Si {} | less)'
    } else {
        pacman -Slq | fzf --preview 'pacman -Si {}' --bind 'enter:execute(pacman -Si {} | less)'
    }
}

# Removes orphaned packages after confirmation from the user.
def "pac prune" [
    --yes (-y) # Remove without confirmation
]: nothing -> nothing {
    if (pacman -Qtdq | lines | is-empty) {
        error make --unspanned { msg: "No unused dependency found." }
    }

    if $yes {
        sudo pacman -Rns ...(pacman -Qtdq | lines)
    }

    let confirm = (input -n 1 $"(ansi green)This process might delete some necessary packages. Are you sure? (ansi grey)\(y/N\)(ansi reset) ")
    if $confirm =~ "[yY]" {
        sudo pacman -Rns ...(pacman -Qtdq | lines)
    }
}

# Displays the dependency tree of a specified installed package.
def "pac tree" [
    pkg: string@pacman_installed_pkgs # Name of the package
]: nothing -> nothing {
    if (which pactree | length) == 0 {
        error make --unspanned { msg: "pactree command isn't isntalled. Install \"pacman-contrib\" package." }
    }

    pactree $pkg | less
}

# Shows reverse dependencies for a specified installed package.
def "pac why" [
    pkg: string@pacman_installed_pkgs  # Name of the package
]: nothing -> nothing {
    if (which pactree | length) == 0 {
        error make --unspanned { msg: "pactree command isn't isntalled. Install \"pacman-contrib\" package." }
    }

    pactree -r $pkg | less
}


def _update_reflector_config [] {
    let fzf_flags = [
        '--multi'
        '--prompt=Country: '
        '--header=Use <Tab> key for selecting multiple'
        '--bind=tab:toggle+clear-query'
        '--preview=echo {+} | to text'
        '--preview-label=Selected Countries'
    ]

    let countries = (echo $available_countries | to text | fzf ...$fzf_flags | cut -d: -f1 | lines | str join ,)

    print $"Selected countries: ($countries)"

    let age = (input -d 12 $"(ansi green)How much time since last synchronized? \(Hours\)(ansi reset) ")
    print $"Selected age: ($age)"

    let protocals = ([https http ftp rsync] | input list --multi 'Select the protocals you want to use' | str join ,)
    print $"Selected protocals: ($protocals)"

    let sorting = ([age rate country score rsync] | input list 'Select the sorting you want to use')
    print $"Selected sorting: ($sorting)"

    let config = {
        countries: $countries
        age: $age
        protocals: $protocals
        sorting: $sorting
    }

    mkdir ~/.cache/reflector

    $config | save -f ~/.cache/reflector/config.json
}

# Updates the mirrorlist using reflector based on user-defined configuration.
def "pac mirror" [
    --update-options (-u) # Update reflector options
]: nothing -> nothing {
    if (which fzf | length) == 0 {
        error make --unspanned { msg: "fzf command isn't isntalled." }
    }
    if (which reflector | length) == 0 {
        error make --unspanned { msg: "reflector command isn't isntalled." }
    }

    if not ("~/.cache/reflector/config.json" | path exists) or $update_options {
        _update_reflector_config
    }

    let config = (open ~/.cache/reflector/config.json)

    let confirm = (input -n 1 $"(ansi green)Would you like to create an backup of exist mirror-list? (ansi grey)\(y/N\)(ansi reset) ")
    if $confirm like "[yY]" {
        sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pac_backup
    }

    let countries = ($config | get countries)
    let age = ($config | get age)
    let protocals = ($config | get protocals)
    let sorting = ($config | get sorting)

    sudo reflector --verbose --country $countries --age $age --protocol $protocals --sort $sorting --save /etc/pacman.d/mirrorlist
}

# Cleans cached files from pacman and AUR helpers after confirmation.
def "pac clean" [
    ...cache_path: string # List of path to look for package caches. It will serach all sub directory of given path
]: nothing -> nothing {
    let confirm = (input -n 1 $"(ansi green)You are about to delete pacman and AUR caches. Are you sure? (ansi grey)\(y/N\)(ansi reset) ")

    if $confirm not-like "[yY]" {
        return
    }

    print $"(ansi green)Clearing pacman caches...(ansi reset)"

    # Keep last 2 version of installed package
    paccache -vrk2
    # Delete all version of uninstalled package
    paccache -vruk0

    mut aur_cache_dirs = []

    for path in [ "~/.cache/yay/" "~/.cache/paru/clone/" ] {
        let p = $path | path expand
        if ($p | path exists) {
            $aur_cache_dirs = ($aur_cache_dirs | append (ls $p -d | get name))
        }
    }
    for path in $cache_path {
        let p = $path | path expand
        if ($p | path exists) {
            $aur_cache_dirs = ($aur_cache_dirs | append (ls $p -d | get name))
        }
    }

    # Keep last 2 version of installed package
    paccache -vrk2 -c ...$aur_cache_dirs
    # Delete all version of uninstalled package
    paccache -ruvk0 -c ...$aur_cache_dirs

    for dir in $aur_cache_dirs {
        if (ls $dir | where name =~ '.*\.tar\.zst' | is-empty) {
            print $"Clearing the cache from '($dir)'"
            rm -vrf $dir
            continue
        }
    }
}
