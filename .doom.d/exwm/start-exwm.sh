#!/bin/sh
  # Set the screen DPI (uncomment this if needed!)
  # xrdb ~/.emacs.d/exwm/Xresources

  # Run the menet compositor
  picom &

  # Enable screen locking on suspend
  # xss-lock -- slock &

  # Fire it up
  exec dbus-launch --exit-with-session emacs -mm -l ~/.doom.d/desktop.el
  bash /home/hrothgar32/.config/polybar/launch.sh
