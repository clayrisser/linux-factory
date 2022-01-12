while [ $# -gt 0 ]; do
    case $1 in
        -e|--export)
            _EXPORT=export
            shift
            ;;
    esac
done


JSON=$(cat | jq)
for k in $(echo $JSON | jq -r '. | keys[]'); do
    echo $_EXPORT \
        $(echo $k | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g' | sed 's/[a-z]/\U&/g')="'"$(echo $JSON | jq -r ".$k")"'"
done
