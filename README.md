# ![cool logo](https://github.com/son-ray/Sonic-Godot-Physics/blob/main/read_me/logo.png)


## About the framework
This is based on marimitoTH's [GoSonic2D](https://github.com/marmitoTH/GoSonic2D), and aims to add more features from the classic Sonic games.

~~(The "+" in the name means "+ More features" not engine improvement.)~~

This framework is being worked on Godot version 3.5.1.

It not compatible with Godot version 4 and up.

## Added features so far:

* Super Sonic, along with all of his ring draining, 50 ring requirement and pallete swapping.
* Music Manager, play all your music by doing MusicManager.play_music(insert audio stream here)
* Spindash
* Camera lag (for spindash, etc.)
* Super Peel Out
* You can now look up and down
* Debug Text for Last State, Current State, Looking Up, Looking Down, Is Rolling, Is Grounded, FPS, etc
* Shield Monitors
* Bubble Shield
* Mostly Mania accurate Drop Dash!
* Can now gain an extra life for every hundred ring
* Rings are now capped at 999, can be uncapped by making cap_rings false in ScoreManager
* Can now attract rings using the lightning shield
* Sonic can now balance on ledges (based on Sonic 3)
* Lightning shield has particles now
* Sonic can now do his pushing animation
* Sonic now has a full idle animation from Sonic 3
* Sonic can now die if he touches the bottom of the camera
* Sonic can now lose rings from damage and will die if none.
* The camera now pans if you look up and down.
* Game Overs are now implemented (after the game over sequence it just restarts the main scene and all the score)
* Time Overs are now implemented
* Sonic will also now respawn if he dies.
* Loading screen after death or Game/Time Over

## Notes:

* Music Manager is still in early development, expect bugs
* Super Sonic is still in late development, expect bugs.
* You can make Sonic take damage as if there were spikes by pressing the Tilde key (~)
* Bubble Shield is not exactly accurate to games, but still functions (since I couldn't translate it to Godot that well.)
* Sonic can only balance at a maximum ground angle of 3
* In the debug screen, "lifes_gained" is one more than how much lives you gained with rings.
* Thank you [Sonic Physics Guide](https://info.sonicretro.org/Sonic_Physics_Guide), for helping me implement most of these features.
* Credits to raphaklaus for the [fading shader](https://github.com/raphaklaus/sonic-palette-fade) used for fading transitions
* Credits to Dicode for the [loading screen script](https://www.youtube.com/watch?v=5aV_GSAE1kM)

## MusicManager functions:

All functions must be ran as ```MusicManager.replace_with_function()```

### ```play_music(AudioStream)```
Stops current track then plays the AudioStream provided.

### ```stop_music()```
Stops current track

### ```fade_out()```
Fades the current track out

### ```fade_in()```
Fades the current track in

### ```extra_life_jingle()```
Plays the extra life jingle. (Mutes the current track then fades the music track back in after jingle.)

### ```reset_volume()```
Resets the volume to the stream_volume variable (adjustable in MusicManager)

### ```replay_music()```
Stops and starts the current track

### ```is_playing()```
Returns a bool if the track is playing anything.
