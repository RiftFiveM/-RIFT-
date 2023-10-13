function RIFT.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(RIFT.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = RIFT.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = RIFT.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("RIFT:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end

AddEventHandler("playerJoining", function()
  RIFT.updateCurrentPlayerInfo()
end)