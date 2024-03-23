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
        if extension == '.ogg' or extension == '.mp3' then --please use .ogg files
            local sound = nil
            local sound_code = string.sub(filename, 1, -5)
            sendDebugMessage("path: " .. mod.path .. 'Assets/' .. filename)
            sound = {sound = love.audio.newSource(mod.path .. 'Assets/' .. filename, 'static')}
            sound.sound_code = sound_code
            table.insert(Custom_Sounds,sound)
        end
    end
end

function Custom_Play_Sound(sound_code,stop_previous_instance, volume, pitch)
    for _, s in pairs(Custom_Sounds) do
        if s.sound_code == sound_code then
            volume = volume or 1
            if pitch then
                s.sound:setPitch(pitch)
            else
                s.sound:setPitch(1)
            end
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
    end
    return false
end

function Custom_Play_Sound(sound_code,stop_previous_instance, volume, pitch)
    if not(sound_code) or G.muted or G.SETTINGS.SOUND.volume == 0 then return end
    for _, s in pairs(Custom_Sounds) do
        if s.sound_code == sound_code then
            volume = volume or 1
            if pitch then
                s.sound:setPitch(pitch)
            else
                s.sound:setPitch(1)
            end
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
    end
    return false
end



----------------------------------------------
------------MOD CODE END----------------------