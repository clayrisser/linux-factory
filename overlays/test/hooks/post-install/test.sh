FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/favorite_color:' | sed 's|^prompt/favorite_color:||g')

echo --- POST INSTALL ---
echo CWD $(pwd)
echo HOME $HOME
echo USER $USER
echo FAVORITE_COLOR $FAVORITE_COLOR
