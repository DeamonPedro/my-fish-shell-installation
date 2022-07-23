function extract -d "Extract all compressed files types" -a file -a target_path
    if test -n "$file"
        if not test -e "$file"
            echo "extract: input file does not exist"
            return
        end
        if test -z "$target_path"
            set target_path '.'
        end
        if not test -e "$target_path"
            mkdir "$target_path"
        end
    else
        echo "extract: missing params"
        return
    end
    set file_without_ext (echo "$file" | sed 's/\.[^.]*$//')
    set mimetype (file -b --mime-type "$file" | sed 's/^.*\///')
    set uncompress_mimetype (file -z -b --mime-type "$file" | sed 's/^.*\///')
    if string match -q "$uncompress_mimetype" x-tar
        switch $mimetype
            case gzip
                echo "[tar] Decompressing file [$file] to [$target_path]..."
                tar -xzf "$file" -C "$target_path" >/dev/null
            case x-bzip2
                echo "[tar] Decompressing file [$file] to [$target_path]..."
                tar -xjf "$file" -C "$target_path" >/dev/null
            case x-xz
                echo "[tar] Decompressing file [$file] to [$target_path]..."
                tar -xJf "$file" -C "$target_path" >/dev/null
            case x-compress
                echo "[tar] Decompressing file [$file] to [$target_path]..."
                tar -zxvf "$file" -C "$target_path" >/dev/null
            case '*'
                echo "extract: unknown file type"
                return
        end
    else
        switch $mimetype
            case gzip x-compress
                echo "[gzip] Decompressing file [$file] to [$target_path/$file_without_ext]..."
                gzip -dck "$file" >"$target_path/$file_without_ext" >/dev/null
            case x-bzip2
                echo "[bzip2] Decompressing file [$file] to [$target_path/$file_without_ext]..."
                bzip2 -dck "$file" >"$target_path/$file_without_ext" >/dev/null
            case x-xz
                echo "[xz] Decompressing file [$file] to [$target_path/$file_without_ext]..."
                xz -dck "$file" >"$target_path/$file_without_ext" >/dev/null
            case x-zip zip
                echo "[zip] Decompressing file [$file] to [$target_path]..."
                unzip "$file" -d "$target_path" >/dev/null
            case x-7z-compressed
                echo "[7z] Decompressing file [$file] to [$target_path]..."
                7z x "$file" -o"$target_path" >/dev/null
            case x-rar-compressed
                echo "[Z] Decompressing file [$file] to [$target_path]..."
                unrar x "$file" "$target_path" >/dev/null
            case x-tar
                echo "[tar] Decompressing file [$file] to [$target_path]..."
                tar -xvf "$file" -C "$target_path" >/dev/null
            case '*'
                echo "extract: unknown file type"
        end
    end
end
