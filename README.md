# ![cool logo](https://github.com/son-ray/Sonic-Godot-Physics/blob/main/read_me/logo.png)


## About the framework
This is based on marimitoTH's [GoSonic2D](https://github.com/marmitoTH/GoSonic2D), and aims to add more features from the classic Sonic games.

This framework is being worked on Godot version 3.5.1.

It has some compatibility issues with 4.0 that I can't be bothered to fix for now.

## Added features so far:

* Spindash
* Camera lag (for spindash, etc.)
* Super Peel Out
* You can now look up and down
* Debug Text for Last State, Current State, Looking Up, Looking Down, Is Rolling, Is Grounded, FPS, etc
* Shield Monitors
* Mostly Mania accurate Drop Dash!
* Can now gain an extra life for every hundred ring
* Rings are now capped at 999, can be uncapped by making cap_rings false in ScoreManager
* Can now attract rings using the lightning shield
* Sonic can now balance on ledges (based on Sonic 3)
* Lightning shield has particles now
* Sonic can now do his pushing animation
* Sonic now has a full idle animation from Sonic 3
* Sonic can now die if he touches the bottom of the camera 
* Sonic will also now respawn if he dies.
* When Sonic runs out of lives, the game will now exit.

## Notes:

* Sonic can only balance at a maximum ground angle of 3
* In the debug screen, "lifes_gained" is one more than how much lives you gained with rings.
* Sonic's dying routine is still a heavy work in progress. It seems to work for the most part.
* Thank you [Sonic Physics Guide](https://info.sonicretro.org/Sonic_Physics_Guide), for helping me implement most of these features.
