# Sonic-Godot-Physics
A fork of marmitoTH's "GoSonic2D" that aims to add more features.

## Added features so far:

* Spindash
* Camera lag (for spindash, etc.)
* Super Peel Out
* You can now look up and down
* Debug Text for Last State, Current State, Looking Up, Looking Down, Is Rolling, Is Grounded
* Shield Monitors
* Mania accurate (mostly) Drop Dash!

## Known Glitch/es

**Flame Shield Boost**

Looks like Classic Sonic learned how to boost.

This glitch can be seen when Sonic performs a frame-perfect fireball spin dash right when he lands on the ground. 
This grants him a sort of "Boost" like in the modern games. This keeps his variable "is_rolling" to true,
and will stay true until the variable is changed (like with a spindash, or a jump). It also prevents him
from rotating on loops, as the game still recognizes Sonic as rolling therefore, it will not rotate his sprite.

![](https://github.com/son-ray/Sonic-Godot-Physics/blob/main/read_me/flame_shield_bug.gif)
