# labwc-dotfiles
this repository contains the configuration files (.files) for labwc which is a wlroots-based window-stacking compositor for Wayland <br>

packages <br>
```
sudo pacman -Syu wayland labwc foot alacritty swaybg libnotify mako polkit-gnome viewnior firefox chromium noto-fonts noto-fonts-cjk noto-fonts-emoji geany xcursor-vanilla-dmz gnome-themes-extra acpid ibus dbus nwg-look intel-media-driver xdg-desktop-portal xdg-desktop-portal-wlr terminus-font vulkan-intel vulkan-mesa-layers zip unzip bash-completion grim slurp fastfetch
```

use labwc with systemd-logind instead of seatd, seatd is dependency for labwc, currently i see harmless warning spams in tty with seatd

add below line in you ~/.bashrc
```
alias labwc='labwc 2>/dev/null'
```

```
sudo usermod -aG video,input <username>
```

place bin folder under ~/.local/
place themes under ~/.themes
place fastfetch, foot, labwc mako in ~/.config folder

this config is using foot as terminal emulator, but install alacritty as it is fallback / default emulator for labwc

Note: make all the scripts in bin folder executable

optional packages - waybar, wofi and greetd 

I have also included configs for waybar and wofi - here in my setup i have not used waybar and wofi, but can easily setup by making changes to rc.xml and autostart scripts inside labwc

![alt text](screen_20260105_212205.png)
