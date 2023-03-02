#!/bin/bash

WOFI_ARGS=${WOFI_ARGS:-}

# `list_geometry` returns the geometry of the focused of visible windows. You can also get they title
# by setting a second argument to `with_description`. The geometry and the title are seperated by `\t`.
#
# Arguments:
#   $1: `focused` or `visible`
#   $2: `with_description` or nothing
#
# Output examples:
#   - with the `with_description` option:
#      12,43 100x200\tTermite
#   - without the `with_description` option:
#      12,43 100x200
function list_geometry () {
	[ "$2" = with_description ] && local append="\t\(.name)" || local append=
	swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.'$1' and .pid) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)'$append'"'
}

WINDOWS=`list_geometry visible with_description`
if [ "$WINDOWS" != "" ]; then
    WINDOWS="
$WINDOWS"
fi
FOCUSED=`list_geometry focused`

CHOICE=`wofi -S dmenu $WOFI_ARGS -p 'Screenshot' << EOF
fullscreen
region
focused$WINDOWS
EOF`
SAVEDIR=${SWAY_INTERACTIVE_SCREENSHOT_SAVEDIR:=~}
mkdir -p -- "$SAVEDIR"
FILENAME="$SAVEDIR/$(date +'%Y-%m-%d-%H%M%S_screenshot.png')"
EXPENDED_FILENAME="${FILENAME/#\~/$HOME}"
case $CHOICE in
    fullscreen)
        grim "$EXPENDED_FILENAME"
	;;
    region)
        grim -g "$(slurp)" "$EXPENDED_FILENAME"
	;;
    focused)
        grim -g "$FOCUSED" "$EXPENDED_FILENAME"
	;;
    '')
        notify-send "Screenshot" "Cancelled"
        exit 0
        ;;
    *)
    	GEOMETRY="`echo \"$CHOICE\" | cut -d$'\t' -f1`"
        grim -g "$GEOMETRY" "$EXPENDED_FILENAME"
esac
# If gimp is installed, prompt the user to edit the captured screenshot
if command -v gimp $>/dev/null
then
    EDIT_CHOICE=`wofi -S dmenu $WOFI_ARGS -lines 2 -p 'Edit Screenshot' << EOF
yes
no
EOF`
    case $EDIT_CHOICE in
        yes)
            gimp "$EXPENDED_FILENAME"
            ;;
        no)
            ;;
        '')
            ;;
    esac
fi
wl-copy < "$EXPENDED_FILENAME"
notify-send "Screenshot" "File saved as <i>'$FILENAME'</i> and copied to the clipboard." -i "$EXPENDED_FILENAME"
