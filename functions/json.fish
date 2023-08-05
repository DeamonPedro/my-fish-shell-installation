function json -d "json short for data-selector" -a 'file' -a 'query'
    if not test -t 0
        set query $file
        set file "/dev/stdin"
    end
    if test -z "$file" -a -z "$query"
        echo "json: invalid arguments"
        return
    end
    cat "$file" | jfq "$query" -j | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
end
