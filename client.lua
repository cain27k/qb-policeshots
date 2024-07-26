local QBCore = exports['qb-core']:GetCoreObject()
local shotBlips = {}


RegisterNetEvent('qb-policeshots:client:NotifyPolice', function(coords)
    if PlayerData.job and PlayerData.job.name == 'police' then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message emergency">Shots fired at {0}, {1}, {2}</div>',
            args = { coords.x, coords.y, coords.z }
        })

        
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Shots Fired')
        EndTextCommandSetBlipName(blip)

        
        table.insert(shotBlips, { blip = blip, coords = coords })

        
        Citizen.SetTimeout(60000, function()
            for i, shot in ipairs(shotBlips) do
                if shot.blip == blip then
                    RemoveBlip(shot.blip)
                    table.remove(shotBlips, i)
                    break
                end
            end
        end)
    end
end)


local function setWaypoint()
    if #shotBlips > 0 then
        local lastShot = shotBlips[#shotBlips]
        SetNewWaypoint(lastShot.coords.x, lastShot.coords.y)
        QBCore.Functions.Notify('Waypoint set to last shots fired location', 'success')
    else
        QBCore.Functions.Notify('No recent shots fired locations available', 'error')
    end
end


RegisterKeyMapping('setshotwaypoint', 'Set Waypoint to Last Shots Fired', 'keyboard', 'F10')
RegisterCommand('setshotwaypoint', setWaypoint, false)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)


RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)


AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PlayerData = QBCore.Functions.GetPlayerData()
    end
end)
