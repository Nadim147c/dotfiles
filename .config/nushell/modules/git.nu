# Git
alias g = git
alias ga = git add
alias gpl = git pull
alias gph = git push
alias gr = git reset
alias gcm = git commit
alias gaa = git add -A
alias gt = git status
alias gd = git diff
alias gpr = git pull --rebase
alias gst = git status
alias grh = git reset --hard
alias grs = git reset --soft
alias grhh = git reset --hard HEAD
alias grsh = git reset --soft HEAD

# Print git log as nushell table
def "git nlog" [
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
