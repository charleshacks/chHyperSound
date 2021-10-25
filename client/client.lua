local activeSounds = {}

--
-- Threads
--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
 
        if next(activeSounds) then
            local playerCoordinates = GetEntityCoords(PlayerPedId())
            local cameraDirection   = getCameraDirection()

            SendNUIMessage({
                type = 'position',

                volume = GetProfileSetting(300),

                camera = cameraDirection,

                coordinates = {
                    x = playerCoordinates.x,
                    y = playerCoordinates.y,
                    z = playerCoordinates.z,
                },
            })

            for soundId, soundData in pairs(activeSounds) do
                if soundData.type == 'entity' then
                    if NetworkDoesEntityExistWithNetworkId(soundData.netId) then
                        local entityId = NetworkGetEntityFromNetworkId(soundData.netId)

                        if entityId and DoesEntityExist(entityId) then
                            SendNUIMessage({
                                type        = 'soundPosition',
                                soundId     = soundId,
                                coordinates = convertLocation({ [1] = GetEntityCoords(entityId), }),
                            })
                        end
                    end
                end
            end
        end
    end
end)

--
-- Functions
--

function getCameraDirection()
    local cameraRotation = GetGameplayCamRot(0)

    local radiansZ = (cameraRotation.z * 0.0174532924)
    local radiansX = (cameraRotation.x * 0.0174532924)
    local xCos     = math.abs(math.cos(radiansX))

    return {
        x = (-math.sin(radiansZ) * xCos),
        y = (math.cos(radiansZ) * xCos),
        z = math.sin(radiansX),
    }
end

function convertLocation(locations)
    local retVal = {}

    for _, location in pairs(locations) do
        if type(location) == 'string' and location == 'self' then
            table.insert(retVal, 'self')
        end

        if type(location) == 'vector3' then
            table.insert(retVal, {
                x = location.x,
                y = location.y,
                z = location.z,
            })
        end

        ::continue::
    end

    return retVal
end

function generateUuid()
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

--
-- NUI Callbacks
--

RegisterNUICallback('soundEnded', function(data, cb)
    cb({})

    activeSounds[data.soundId] = nil
end)

--
-- Events
--

RegisterNetEvent('__chHyperSound:play', function(soundId, soundName, isLooped, location, maxDistance)
    if not soundId or (type(soundId) == 'number' and soundId <= 0) then
        soundId = generateUuid()
    end

    if type(location) == 'string' then
        if location == 'self' then
            location = { [1] = 'self', }
        else
            location = Config.PredefinedLocations[location]

            if not location then
                return
            end
        end
    end

    if type(location) == 'vector3' then
        location = {
            [1] = location,
        }
    end

    activeSounds[soundId] = {
        type = 'location',
    }

    SendNUIMessage({
        type = 'play',

        soundId      = soundId,
        soundName    = soundName,
        coordinates  = convertLocation(location),
        maxDistance  = maxDistance,
        isLooped     = isLooped,
    })
end)

RegisterNetEvent('__chHyperSound:playOnEntity', function(entityNetId, soundId, soundName, isLooped, maxDistance)
    if not soundId or (type(soundId) == 'number' and soundId <= 0) then
        soundId = generateUuid()
    end

    if not NetworkDoesEntityExistWithNetworkId(entityNetId) then
        return
    end

    local entityId = NetworkGetEntityFromNetworkId(entityNetId)

    if not entityId or not DoesEntityExist(entityId) then
        return
    end

    activeSounds[soundId] = {
        type  = 'entity',
        netId = entityNetId,
    }

    SendNUIMessage({
        type = 'play',

        soundId     = soundId,
        soundName   = soundName,
        coordinates = convertLocation({ [1] = GetEntityCoords(entityId), }),
        maxDistance = maxDistance,
        isLooped    = isLooped,
    })
end)

RegisterNetEvent('__chHyperSound:stop', function(soundId)
    SendNUIMessage({
        type    = 'stop',
        soundId = soundId,
    })
end)