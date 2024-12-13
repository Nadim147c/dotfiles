local SNIPPETS=(
    OMZP::git-auto-fetch
    OMZP::extract
    OMZP::sudo
    OMZP::man
)

zinit light-mode depth1 id-as is-snippet wait for $SNIPPETS
