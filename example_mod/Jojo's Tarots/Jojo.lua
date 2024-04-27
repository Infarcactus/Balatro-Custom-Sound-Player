--- STEAMODDED HEADER
--- MOD_NAME: JoJo's Tarots
--- MOD_ID: jojo_tarot
--- MOD_AUTHOR: [infarctus]
--- MOD_DESCRIPTION: Listen to jojo stand name when playing tarots cards
----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.jojo_tarot()
    register_sound_global("jojo_tarot")
    -- these were added but not used in my mod to explain other functions better (they work)
    sendDebugMessage(" try " .. tostring((register_temporary_replace_sound_played({button = "The World"},5) )))
    register_replace_sound_played({music1 = {sound_code ="The World",stop_previous_instance = false,volume = 0.1} })
    register_replace_sound_played({music2 = {sound_code ="The World",stop_previous_instance = false,volume = 1} })
    register_replace_sound_played({music3 = {sound_code ="The World",stop_previous_instance = false,volume = 1} })
    register_replace_sound_played({music4 = {sound_code ="The World",stop_previous_instance = false,volume = 1} })
    register_replace_sound_played({music5 = {sound_code ="The World",stop_previous_instance = false,volume = 1} })
    register_replace_sound_played({cardSlide1 = {sound_code ="Death",stop_previous_instance = true, volume = 1,pitch=0.5,continue_base_sound=true} })
    register_temporary_stop_sound({"whoosh","something"},10)
    sendDebugMessage(" try " ..tostring((register_temporary_stop_sound("button",2) ) ) )
    register_stop_sound("music1")
    -- end of added functions for explanation
end
----------------------------------------------
------------MOD CODE END----------------------
