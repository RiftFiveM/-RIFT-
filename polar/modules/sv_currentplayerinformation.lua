function Polar.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(Polar.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = Polar.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = Polar.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("Polar:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end

AddEventHandler("playerJoining", function()
  Polar.updateCurrentPlayerInfo()
end)