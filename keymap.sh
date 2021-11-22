#!/usr/bin/bash

xmodmap -e "keycode 108 = Hangul"
xmodmap -e "keycode 105 = Hangul_Hanja"
xmodmap -e "keycode 66 = Hangul"
xmodmap -pke > ~/.Xmodmap
