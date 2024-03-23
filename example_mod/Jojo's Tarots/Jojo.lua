--- STEAMODDED HEADER
--- MOD_NAME: JoJo's Tarots
--- MOD_ID: jojo_tarot
--- MOD_AUTHOR: [infarctus]
--- MOD_DESCRIPTION: Listen to jojo stand name when playing tarots cards
----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.jojo()
    Add_Custom_Sound_Global("jojo_tarot")
    Add_Custom_Stop_Sound_to_table("UwU")
end

local Orginial_Card_use_consumeable = Card.use_consumeable
function Card:use_consumeable(area, copier)
    Custom_Play_Sound(self.ability.name,false,1,1)
    local temp_ret = Orginial_Card_use_consumeable(self, area, copier)
    return temp_ret
end
----------------------------------------------
------------MOD CODE END----------------------