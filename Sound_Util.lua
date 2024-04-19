--- STEAMODDED HEADER
--- MOD_NAME: Sound Util
--- MOD_ID: Sound_Util
--- MOD_AUTHOR: [infarctus]
--- MOD_DESCRIPTION: Utility mod to facilitate adding sound
----------------------------------------------
------------MOD CODE -------------------------
local Custom_Sounds = {}

function Add_Custom_Sound_Global(modID)
    local mod = SMODS.findModByID(modID)
    for _, filename in ipairs(love.filesystem.getDirectoryItems(mod.path .. 'Assets')) do
        local extension = string.sub(filename, -4)
        if extension == '.ogg' or extension == '.mp3' or extension=='.wav' then --please use .ogg or .wav files
            local sound = nil
            local sound_code = string.sub(filename, 1, -5)
            sound = {
                sound = love.audio.newSource(mod.path .. 'assets/sounds/' .. filename,
                ((string.find(sound_code, 'music') or string.find(sound_code, 'stream')) and "stream" or 'static'))
            }
            sound.sound_code = sound_code
            Custom_Sounds[sound_code]=sound
        end
    end
end

function Custom_Play_Sound(sound_code,stop_previous_instance, volume, pitch)
    if Custom_Sounds[sound_code] then
        local s = Custom_Sounds[sound_code]
        stop_previous_instance = (stop_previous_instance == nil) and true or stop_previous_instance
        volume = volume or 1
        s.sound:setPitch(pitch or 1)
        local sound_vol = volume*(G.SETTINGS.SOUND.volume/100.0)*(G.SETTINGS.SOUND.game_sounds_volume/100.0)
        if sound_vol <= 0 then
            s.sound:setVolume(0)
        else
            s.sound:setVolume(sound_vol)
        end
        if stop_previous_instance and s.sound:isPlaying() then
            s.sound:stop()
        end
        love.audio.play(s.sound)
        return true
    end
    return false
end

local Custom_Stop_Sound = {}

function Add_Custom_Stop_Sound(sound_code)
    if type(sound_code)=="table" then
        for _,s_c in ipairs(sound_code) do
            if type(s_c)=="string" then
                Custom_Stop_Sound[s_c] = true
            else
                return false
            end
        end
    elseif type(sound_code)=="string" then
        table.insert(Custom_Stop_Sound,sound_code)
    else
        return false
    end
    return true
end

local Custom_Replace_Sound = {}

function Add_Custom_Replace_Sound(replace_code_table)
    if type(replace_code_table)=="table" then
        for original_sound_code,replacement_sound_code in pairs(replace_code_table) do
            if type(replacement_sound_code)=="table" or type(replacement_sound_code)=="string" then
                Custom_Replace_Sound[original_sound_code] = replacement_sound_code
            else
                return false
            end
        end
    else
        return false
    end
    return true
end

local Original_play_sound = play_sound
function play_sound(sound_code, per, vol)
    if Custom_Replace_Sound[sound_code] then
        if type(Custom_Replace_Sound[sound_code]) == "table" then
            local sound_args = Custom_Replace_Sound[sound_code]
            sendDebugMessage("testing " .. tostring(sound_args.sound_code))
            Custom_Play_Sound(sound_args.sound_code,sound_args.stop_previous_instance,sound_args.volume,sound_args.pitch)
            if not(sound_args.continue_base_sound) then
                return
            end
        else
            Custom_Play_Sound(Custom_Replace_Sound[sound_code])
            return
        end
    end
    if Custom_Stop_Sound[sound_code] then
        return
    end
    sendDebugMessage("sound_code : " .. sound_code)
    return Original_play_sound(sound_code, per, vol)
end

local Orginial_modulate_sound=modulate_sound
function modulate_sound(dt)
    --Control the music here
    local desired_track =  
          G.video_soundtrack or
          (G.STATE == G.STATES.SPLASH and '') or
          (G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED and 'music2') or
          (G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED and 'music3') or
          (G.booster_pack and not G.booster_pack.REMOVED and 'music2') or
          (G.shop and not G.shop.REMOVED and 'music4') or
          (G.GAME.blind and G.GAME.blind.boss and 'music5') or 
          ('music1')

    if Custom_Replace_Sound[desired_track] then
        if type(Custom_Replace_Sound[desired_track]) == "table" then
            local sound_args = Custom_Replace_Sound[desired_track]
            Custom_Play_Sound(sound_args.sound_code,sound_args.stop_previous_instance,sound_args.volume, sound_args.pitch)
            if not (sound_args.continue_base_sound) then return end
        else
            Custom_Play_Sound(Custom_Replace_Sound[desired_track])
            return
        end
    end
    if Custom_Stop_Sound[desired_track] then 
        return 
    end
    return Orginial_modulate_sound(dt)
end

----------------------------------------------
------------MOD CODE END----------------------
