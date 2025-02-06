# Git
alias gpl = git pull
alias gph = git push
alias gr = git reset
alias gcm = git commit
alias gaa = git add -A
alias gpr = git pull --rebase

# Print git log as nushell table
def "nit log" [
    --long # All item parsed on the table
]: nothing -> table {
    # There is invalid parsing error in nushell
    let log = (sh -c "git log --pretty=%h»¦«%s»¦«%aN»¦«%aD»¦«%H»¦«%aE" | lines | reverse | split column "»¦«" commit subject name date hash email)

    if $long {
        $log | upsert date {|it| $it.date | into datetime}
    } else {
        $log | upsert date {|it| $it.date | into datetime} | select commit subject name date
    }
}

# Print print list of git authors
def "nit authors" []: nothing -> table {
    # There is invalid parsing error in nushell
    let log = (sh -c "git log --pretty=%aN»¦«%aE" | lines | reverse | split column "»¦«" name email)

    $log | uniq --count | each {|it| $it.value | upsert commits $it.count}
}
