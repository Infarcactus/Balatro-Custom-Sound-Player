-- this is the core version that goes in \Steamodded\core and need to replace sound.lua for lovely injector

SMODS.SOUND_SOURCES = {}

function register_sound_global(modID)
    local mod = SMODS.findModByID(modID)
    for _, filename in ipairs(love.filesystem.getDirectoryItems(mod.path ..'assets/sounds/')) do
        local extension = string.sub(filename, -4)
        if extension == '.ogg' or extension == '.mp3' or extension == '.wav' then -- please use .ogg or .wav files
            local sound = nil
            local sound_code = string.sub(filename, 1, -5)
            sound = {
                sound = love.audio.newSource(mod.path .. 'assets/sounds/' .. filename,
                ((string.find(sound_code, 'music') or string.find(sound_code, 'stream')) and "stream" or 'static'))
            }
            sound.sound_code = sound_code
            SMODS.SOUND_SOURCES[sound_code] = sound
            sendInfoMessage("Registered sound '" .. sound_code .. "' from file " .. filename, 'SoundAPI')
        end
    end
end

function register_sound(name, path, filename) -- Keep that here to support old versions
    local sound_code = string.sub(filename, 1, -5)
    local s = {
        sound = love.audio.newSource(
            path .. "assets/sounds/" .. filename,
            ((string.find(sound_code, 'music') or string.find(sound_code, 'stream')) and "stream" or 'static')
        ),
        filepath = path .. "assets/sounds/" .. filename
    }
    -- s.original_pitch = 1
    -- s.original_volume = 0.75
    s.sound_code = name

    sendInfoMessage("Registered sound '" .. name .. "' from file " .. filename, 'SoundAPI')
    SMODS.SOUND_SOURCES[name] = s
end

function Custom_Play_Sound(sound_code, stop_previous_instance, volume, pitch)
    if SMODS.SOUND_SOURCES[sound_code] then
        --sendTraceMessage("found sound code: " .. sound_code, 'SoundAPI')
        local s = SMODS.SOUND_SOURCES[sound_code]
        stop_previous_instance = (stop_previous_instance == nil) and true or stop_previous_instance
        volume = volume or 1
        s.sound:setPitch(pitch or 1)
        local sound_vol = volume * (G.SETTINGS.SOUND.volume / 100.0) * (G.SETTINGS.SOUND.game_sounds_volume / 100.0)
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

SMODS.STOP_SOUNDS = {}

function register_stop_sound(sound_code)
    if type(sound_code) == "table" then
        for _, s_c in ipairs(sound_code) do
            if type(s_c) == "string" then
                SMODS.STOP_SOUNDS[s_c] = true
            else
                return false
            end
        end
    elseif type(sound_code) == "string" then
        SMODS.STOP_SOUNDS[sound_code] = true
    else
        return false
    end
    return true
end

SMODS.REPLACE_SOUND_PLAYED = {}

function register_replace_sound_played(replace_code_table)
    if type(replace_code_table) == "table" then
        for original_sound_code, replacement_sound_code in pairs(replace_code_table) do
            if type(replacement_sound_code) == "table" or type(replacement_sound_code) == "string" then
                SMODS.REPLACE_SOUND_PLAYED[original_sound_code] = replacement_sound_code
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
    if SMODS.REPLACE_SOUND_PLAYED[sound_code] then
        if type(SMODS.REPLACE_SOUND_PLAYED[sound_code]) == "table" then
            local sound_args = SMODS.REPLACE_SOUND_PLAYED[sound_code]
            Custom_Play_Sound(sound_args.sound_code,sound_args.stop_previous_instance,sound_args.volume, sound_args.pitch)
            if not (sound_args.continue_base_sound) then return end
        else
            Custom_Play_Sound(SMODS.REPLACE_SOUND_PLAYED[sound_code])
            return
        end
    end
    if SMODS.STOP_SOUNDS[sound_code] then return end
    return Original_play_sound(sound_code, per, vol)
end


local Old_music_being_played = ''
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
    
    if not(Old_music_being_played==desired_track) then
        if SMODS.REPLACE_SOUND_PLAYED[Old_music_being_played] then
            local sound_args=SMODS.REPLACE_SOUND_PLAYED[Old_music_being_played]
            if type(sound_args)=='table' then
                SMODS.SOUND_SOURCES[sound_args.sound_code].sound:stop()
            else
                SMODS.SOUND_SOURCES[sound_args].sound:stop()
            end
        end
        Old_music_being_played=desired_track
    end

    if SMODS.REPLACE_SOUND_PLAYED[desired_track] then
        if type(SMODS.REPLACE_SOUND_PLAYED[desired_track]) == "table" then  
            local sound_args = SMODS.REPLACE_SOUND_PLAYED[desired_track]
            Custom_Play_Sound(sound_args.sound_code,sound_args.stop_previous_instance,sound_args.volume, sound_args.pitch)
            if not (sound_args.continue_base_sound) then return end
        else
            Custom_Play_Sound(SMODS.REPLACE_SOUND_PLAYED[desired_track])
            return
        end
    end
    if SMODS.STOP_SOUNDS[desired_track] then
        return 
    end
    
    return Orginial_modulate_sound(dt)
end
