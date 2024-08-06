function copy {
    local input base64_output
    input=$(cat)
    base64_output=$(echo -n "$input" | openssl base64)

    printf "\e]52;c;%s\a" "$base64_output"

    echo "text copied to clipboard using ansi..."
}
