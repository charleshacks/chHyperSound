# chHyperSound

A fully-featured 3D positional audio sound effect system for FiveM.

## Features

- 3D posititional audio based on gameplay camera.
- Play synchronized sound from multiple "speakers."
- Attach audio to entities, 3D positional audio follows them.
- Automatically uses player's SFX Volume settings.
- Supports looped sounds.

### Limitations

- Currently only Ogg Vorbis (`.ogg`) audio files are supported.

## Installation

Download the latest [release](https://github.com/charleshacks/chHyperSound/releases) and install it into your FiveM resources folder. Add `start chHyperSound` to your server configuration. That's it!

## Configuration

All configuration is handled through `config.lua`.

| Config | Default | Description |
| - | - | - |
| `AllowFromClient` | `false` | Allows clients to trigger sounds on themselves and other clients. Off by default for security reasons.
| `DefaultDistance` | `100.0` | Default maximum distance for sounds when a distance is not specified.
| `PredefinedLocations` | `(table)` | Predefined groups of speakers.

### Predefined Locations

You can predefine a set of speakers under predefined locations. To play sound from a predefined location, pass the location name (key) as the `location` parameter in the play events.

An example, using the three banks of speakers at Vinewood Bowl.

```lua
Config.PredefinedLocations = {
    ['vinewoodBowl'] = {
        [1] = vector3(669.9,  572.48, 141.0),
        [2] = vector3(682.65, 567.69, 146.0),
        [3] = vector3(695.35, 563.12, 141.0),
    },
}
```

### Sound files

Add your sound files to `/sounds`. Currently only Ogg Vorbis files are supported.

## API

chHyperSound exposes two events for playing sound - `chHyperSound:play` and `chHyperSound:playOnEntity`. `play` will play a sound from a single or set of coordinates, and `playonEntity` will play sound from an entity (ped, vehicle, or other networked entity.)

Additionally, a `chHyperSound:stop` event is available to stop playing a sound.

### chHyperSound:play

```lua
TriggerEvent('chHyperSound:play', soundId, soundName, isLooped, location, maxDistance, targetId)
```

| Parameter | Type | Description |
| - | - | - |
| `soundId` | `string\|number` | Random Sound ID, used for stopping the sound. Pass `-1` to allow one to be randomly generated.
| `soundName` | `string` | Name of the sound in the `/sounds` folder (excluding extension.)
| `isLooped` | `boolean` | If the sound should be looped until stopped or not.
| `location` | `string\|vector3\|table` | Location to play sound from. Can be a single `vector3`, a table of `vector3`'s, or the key of a predefined location.
| `maxDistance` | `nil\|number` | Maximum distance the sound can be heard from. Optional.
| `targetId` | `nil\|number` | Pass a player ID to make the sound be heard only by them. Pass `nil` or `-1` to allow all players in range to hear the sound.

### chHyperSound:playOnEntity

```lua
TriggerEvent('chHyperSound:playOnEntity', entityNetId, soundId, soundName, isLooped, maxDistance, targetId)
```

| Parameter | Type | Description |
| - | - | - |
| `entityNetId` | `number` | Network ID of the entity to play the sound from.
| `soundId` | `string\|number` | Random Sound ID, used for stopping the sound. Pass `-1` to allow one to be randomly generated.
| `soundName` | `string` | Name of the sound in the `/sounds` folder (excluding extension.)
| `isLooped` | `boolean` | If the sound should be looped until stopped or not.
| `maxDistance` | `nil\|number` | Maximum distance the sound can be heard from. Optional.
| `targetId` | `nil\|number` | Pass a player ID to make the sound be heard only by them. Pass `nil` or `-1` to allow all players in range to hear the sound.

### chHyperSound:stop

```lua
TriggerEvent('chHyperSound:stop', soundId, targetId)
```

| Parameter | Type | Description |
| - | - | - |
| `soundId` | `string` | The Sound ID to stop playing.
| `targetId` | `nil\|number` | Pass a player ID to stop the sound on a single player, or pass `nil` or `-1` to stop the sound on all players.

## Examples

### Play `example.ogg` from a coordinate.

```lua
TriggerEvent('chHyperSound:play', -1, 'example', false, vector3(123.45, 678.90, 64.0), 30.0)
```

### Play `example.ogg` from a vehicle with Net ID 123.

```lua
TriggerEvent('chHyperSound:playOnEntity', 123, -1, 'example', false, 30.0)
```

### Stop a sound with Sound ID 123.

```lua
TriggerEvent('chHyperSound:stop', 123)
```

## License

Copyright for `nui/lib/lodash.min.js` are held by OpenJS Foundation and other contributors.

Copyright for portions of `nui/lib/howler.core.js` and `nui/lib/howler.spatial.js` are held by James Simpson of GoldFire Studios, 2013-2020.

All other copyright are held by CharlesHacks, 2021 and made available under the MIT license.

Please see [LICENSE](LICENSE) for more information.
