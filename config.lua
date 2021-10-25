Config = {}

-- Enable to allow clients to trigger play events. This can be
-- dangerous as a malicious client with a mod menu could
-- trigger sounds on every player.
Config.AllowFromClient = true

-- Default maximum distance for sound to travel if not specified
-- manually in the play event.
Config.DefaultDistance = 100.0

-- Predefined locations allow you to pass a location name as the
-- "location" event parameter instead of a list of vector3's.
Config.PredefinedLocations = {
    ['vinewoodBowl'] = {
        [1] = vector3(669.9,  572.48, 141.0),
        [2] = vector3(682.65, 567.69, 146.0),
        [3] = vector3(695.35, 563.12, 141.0),
    },
}