function gh-file() {
	echo $1 | sed 's|blob|raw' | xargs wget
}
