--- STEAMODDED HEADER
--- MOD_NAME: JoJo's Tarots
--- MOD_ID: jojo_tarot
--- MOD_AUTHOR: [infarctus]
--- MOD_DESCRIPTION: Listen to jojo stand name when playing tarots cards
----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.jojo_tarot()
    Add_Custom_Sound_Global("jojo_tarot")
    -- these were added but not used in my mod to explain other functions better (they work)
    Add_Custom_Replace_Sound({button = "The World"})
    Add_Custom_Replace_Sound({paper1 = {sound_code ="The World",volume = 0.01} })
    Add_Custom_Replace_Sound({cardSlide1 = {sound_code ="Death",stop_previous_instance = true, volume = 1,pitch=1,continue_base_sound=true} })
    Add_Custom_Stop_Sound({"whoosh","something"})
    Add_Custom_Stop_Sound("whoosh1")
    -- end of added functions for explanation
end

local Orginial_Card_use_consumeable = Card.use_consumeable
function Card:use_consumeable(area, copier)
    Custom_Play_Sound(self.ability.name,false,1,1)
    local temp_ret = Orginial_Card_use_consumeable(self, area, copier)
    return temp_ret
end
----------------------------------------------
------------MOD CODE END----------------------
