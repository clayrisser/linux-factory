JSON=$(cat | jq)
for k in $(echo $JSON | jq -r '. | keys[]'); do
    echo export \
        $(echo $k | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g' | sed 's/[a-z]/\U&/g')="'"$(echo $JSON | jq -r ".$k")"'"
done
