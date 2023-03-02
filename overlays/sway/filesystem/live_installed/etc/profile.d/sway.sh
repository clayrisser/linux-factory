if [ "$DEFAULT_BACKEND" = "wayland" ]; then
    export GDK_BACKEND=wayland
    export WINIT_UNIX_BACKEND=wayland
    export CLUTTER_BACKEND=wayland
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland
    export MOZ_ENABLE_WAYLAND=1
    if ! ((cat $HOME/.config/electron-flags.conf 2>/dev/null || true) | grep -qE '^--enable-features=WaylandWindowDecorations$'); then
        echo '--enable-features=WaylandWindowDecorations' >> $HOME/.config/electron-flags.conf
    fi
    if ! ((cat $HOME/.config/electron-flags.conf 2>/dev/null || true) | grep -qE '^--ozone-platform-hint=auto$'); then
        echo '--ozone-platform-hint=auto' >> $HOME/.config/electron-flags.conf
    fi
    if ! ((cat $HOME/.config/electron13-flags.conf 2>/dev/null || true) | grep -qE '^--enable-features=UseOzonePlatform$'); then
        echo '--enable-features=UseOzonePlatform' >> $HOME/.config/electron13-flags.conf
    fi
    if ! ((cat $HOME/.config/electron13-flags.conf 2>/dev/null || true) | grep -qE '^--ozone-platform-hint=auto$'); then
        echo '--ozone-platform-hint=auto' >> $HOME/.config/electron13-flags.conf
    fi
else
    unset CLUTTER_BACKEND
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    export SDL_VIDEODRIVER=x11
    export WINIT_UNIX_BACKEND=x11
    sed -i '/^--enable-features=WaylandWindowDecorations$/d' $HOME/.config/electron-flags.conf 2>/dev/null || true
    sed -i '/^--ozone-platform-hint=auto$/d' $HOME/.config/electron-flags.conf 2>/dev/null || true
    sed -i '/^--enable-features=UseOzonePlatform$/d' $HOME/.config/electron13-flags.conf 2>/dev/null || true
    sed -i '/^--ozone-platform-hint=auto$/d' $HOME/.config/electron13-flags.conf 2>/dev/null || true
fi
