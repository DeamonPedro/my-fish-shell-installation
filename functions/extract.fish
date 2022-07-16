function extract -d "Extract all compressed files types"
    if not test -n "$argv"
        echo "extract: invalid file"
        return
    end
    for file in $argv
        if string match -q "*.tar*" $file
            switch $file
                case "*.gz"
                    tar -xzf $file
                case "*.bz2"
                    tar -xjf $file
                case "*.xz"
                    tar -xJf $file
                case "*.tar"
                    tar -xf $file
            end
        else if string match -qr ".*\\.(([gx]z\$)|(bz2\$)|(zip\$))" $file
            switch $file
                case "*.gz"
                    gunzip -dk $file
                case "*.bz2"
                    bzip2 -dk $file
                case "*.xz"
                    xz -dk $file
                case "*.zip"
                    unzip $file
            end
        else
            echo "extract: invalid file"
        end
    end
end