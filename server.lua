local QBCore = exports['qb-core']:GetCoreObject()


AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]

        if IsEntityAPed(victim) and IsEntityAPed(attacker) then
            if IsPedAPlayer(attacker) and not IsPedAPlayer(victim) then
                local playerId = NetworkGetPlayerIndexFromPed(attacker)
                local coords = GetEntityCoords(attacker)

                
                TriggerClientEvent('qb-policeshots:client:NotifyPolice', -1, coords)
            end
        end
    end
end)
