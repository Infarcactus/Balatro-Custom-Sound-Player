# Balatro-Custom-Sound-Player

This is for Steamodded

.mp3 can be used but it's not recommended please use .ogg or .wav

## FUNCTIONS

## register_sound_global(modID)
You give this function your modID and it'll search and load every sound in the `assets/sounds` folder next to your .lua file.  
The name of every sound file will be the sound_code (without the extension) so for example TEST.ogg its sound_code is TEST (it's case sensitive)  

### Custom_Play_Sound(sound_code,stop_previous_instance, volume, pitch)
This is the main player of custom_sound everytime something plays a custom sound it calls this function.  
Arguments :
  - sound_code : the sound_code from the sound file you wanna play
  - stop_previous_instace : set to false by default, if you wanna play a sound and it's already playing should we stop it to play the new one ?
  - volume : set to 1 by default
  - pitch : set to 1 by default

## register_stop_sound(sound_code) 
This functions directly interacts with the base game and stops the desired sound_code from the base game  
Arguments :
  - sound_code : the sound_code you wanna stop (it can be a single string or a table of strings)

## register_temporary_stop_sound(sound_code,number_repeat)
Same as register_stop_sound but will only trigger the desired number of time
Arguments :
  - sound_code : the sound_code you wanna stop (it can be a single string or a table of strings)
  - number_repeat : the number of time we should keep it to stop sounds

## register_replace_sound_played(replace_code_table) 
This function also directly interacts with the base game but instead of completely stopping the sound from the base game, it stops it and plays a desired one instead  
replace_code_table:  
Structure of replace_code_table:  
``{base_sound_code = "custom_sound_code"}`` if you don't want to customize the playing sound volume, pitch, etc  
otherwise if you want to customize :  
``{base_sound_code = {sound_code ="custom_sound_code",volume = X}}`` with each arguments can be an argument of Custom_Play_Sound(sound_code,stop_previous_instance, volume, pitch)  
Plus continue_base_sound that can be set to true to still play the base sound_code after playing the custom one    
A full one will look like this :  
```lua
{
  base_sound_code =
  {
    sound_code ="custom_sound_code",
    stop_previous_instance = bool,
    volume = X,
    pitch=X,
    continue_base_sound=bool
  }
}
```

## register_temporary_replace_sound_played(sound_code,number_repeat)
Same as register_replace_sound_played but will only trigger the desired number of time
Arguments :
  - replace_code_table : same as register_replace_sound_played
  - number_repeat : the number of time we should keep it to replace sounds

## play_sound
play_sound is from the base game, it's modified non destructively to be able to do manipulation on it with Add_Custom_Stop_Sound or Add_Custom_Replace_Sound

## modulate_sound
modulate_sound is from the base game it is what handles the music being played, it's modified non destructively to be able to do manipulation on it with Add_Custom_Stop_Sound or Add_Custom_Replace_Sound
