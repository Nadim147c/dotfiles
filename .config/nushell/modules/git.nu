# Git
alias gpl = git pull
alias gph = git push
alias gr = git reset
alias gcm = git commit
alias gaa = git add -A
alias gpr = git pull --rebase

def _error [msg: string] {
    error make --unspanned { msg: $msg }
}

def _git_check [] {
    let work_tree = ((git rev-parse --is-inside-work-tree | complete | get exit_code) != 0)
    let git_directory = ((git rev-parse --is-inside-git-dir | complete | get exit_code) != 0)
    if $work_tree and $git_directory {
        _error "Not inside a git repo"
    }
}

# Print git log as nushell table
def "nit log" [
    --long # All item parsed on the table
]: nothing -> table {
    _git_check
    # There is invalid parsing error in nushell
    let log = (git log --pretty=%h»¦«%s»¦«%aN»¦«%aD»¦«%H»¦«%aE | lines | reverse | split column "»¦«" commit subject name date hash email)

    if $long {
        $log | upsert date {|it| $it.date | into datetime}
    } else {
        $log | upsert date {|it| $it.date | into datetime} | select commit subject name date
    }
}

# Print print list of git authors
def "nit authors" []: nothing -> table {
    _git_check

    # There is invalid parsing error in nushell
    let log = (git log --pretty=%aN»¦«%aE | lines | split column "»¦«" name email)

    $log | uniq --count | each {|it| $it.value | upsert commits $it.count} | sort-by count
}

# Print print list of git authors
def "nit summary" []: nothing -> record {
    _git_check

    let commits = (
        git log --pretty="%aN»¦«%aE»¦«%aD" |
        lines |
        split column "»¦«" name email date |
        upsert date {|it| $it.date | into datetime}
    )

    if ($commits | is-empty) {
        _error "There are no commits in this git work tree"
    }

    let authors = (
        $commits |
        group-by { $"($in.name) <($in.email)>" } |
        transpose |
        rename authors commits |
        upsert commits {$in | length} |
        first 3
    )

    let total_commits = ($commits | length)
    let first_commit = ($commits | last | get date | format date "%d %B %Y")
    let last_commit = ($commits | first | get date)

    let days = ($commits | each { $in.date | format date "%d %B %Y"})
    let active = ($days | uniq | length)
    let streak = ($days | uniq --count | sort-by count --reverse | rename date commits | first 3)

    let files = (git ls-files | wc -l | into int)

    let branch = (git rev-parse --abbrev-ref HEAD)

    {
        project: ($env.PWD | path basename)
        branch: $branch
        created: $first_commit
        last_active: $last_commit
        commits: $total_commits
        active: $"($active) days"
        files: $files
        streak: $streak
        authors: $authors
    }
}

