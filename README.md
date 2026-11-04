# Roblox hitbox panel

For a Roblox game you build in Roblox Studio.

1. Add `HitboxServer.server.lua` as a Script in ServerScriptService.
2. Add `HitboxPanel.client.lua` as a LocalScript in StarterPlayer > StarterPlayerScripts.
3. Run the game and adjust the slider or enter a percentage.

The server script defines MAX_SIZE at 100%. At 0% the added hitbox is hidden and disabled. Existing character collision parts are unchanged. Connect the added hitbox to your own damage or collision logic.
