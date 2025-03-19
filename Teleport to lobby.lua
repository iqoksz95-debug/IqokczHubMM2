local function TeleportToLobby()
    Plr.Character.HumanoidRootPart.CFrame = workspace.Lobby.Spawns.Spawn.CFrame
end

createButton(tabs[4], "Teleport to lobby").MouseButton1Click:Connect(TeleportToLobby)
