function getmagnet -d "magnet link extrator"
    set recusive 0
    for arg in (seq (count $argv))
        if test "$argv[$arg]" = -r
            set recusive 1
            set -e argv[$arg]
        end
    end
    if test -t 0
        set url $argv[1]
        if test -z "$url"
            echo "getmagnet: invalid arguments"
            return
        end
        set content (curl -s "$url")
    else
        set content (cat /dev/stdin)
    end
    set links (echo $content | grep -Pioh 'magnet:\?xt=urn:[a-z0-9]+:[^" ]*')
    if test -z "$links"
        if test $recusive -eq 1
            set urls (echo $content | grep -Po '<a [^>]*>' | grep 'target="_blank"' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*")
            if test -n "$urls"
                echo "getmagnet: found $(count $urls) urls"
                for url in $urls
                    getmagnet "$url"
                end
            else
                echo "getmagnet: no links found"
            end
        else
            echo "getmagnet: magnet links not found"

        end
        return
    end
    for index in (seq (count $links))
        set link $links[$index]
        set name (echo "$link" | grep -Pioh '(?<=;dn=).*?(?=&amp)')
        set nameF (echo "$name" | sed "s@+@ @g
s@%@\\\\x@g" | xargs -0 printf "%b")
        if test -z "$nameF"
            set nameF $link
        end
        echo "$index) $nameF"
    end
    set choice (read -n 1 -P "[$(seq -s ',' (count $links))]:")
    if contains $choice (seq (count $links))
        echo "Opening: $links[$choice]"
        xdg-open $links[$choice]
    else
        echo "getmagnet: invalid option"
    end
end
