function getmagnet -d "magnet link extrator" -a 'url'
    if test -t 0
        if test -z "$url"
            echo "getmagnet: invalid arguments"
            return
        end
        set links (curl -s "$url" | grep -Pioh 'magnet:\?xt=urn:[a-z0-9]+:[^" ]*')
    else
        set links (cat /dev/stdin | grep -Pioh 'magnet:\?xt=urn:[a-z0-9]+:[^" ]*')
    end
    if test -z "$links"
        echo "getmagnet: magnet links not found"
        return
    end
    for index in (seq (count $links))
        set link $links[$index]
        set name (echo "$link" | grep -Pioh '(?<=;dn=).*?(?=&amp)')
        set nameF (echo "$name" | sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b")
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