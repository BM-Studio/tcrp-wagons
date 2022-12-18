local QRCore = exports['qr-core']:GetCoreObject()
--[[ RegisterServerEvent('tcrp-wagons:renameWagon', function(input)
    local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    for k,v in pairs(input) do
        print(k .. " : " .. v)
        print('break')
        print(v)
        MySQL.update('UPDATE player_wagons SET name = ? , {v,})
    end
end) ]]

RegisterServerEvent('tcrp-wagons:server:BuyWagon', function(price, model, newnames,comps)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    if (Player.PlayerData.money.cash < price) then
        print("buy a wagon")
        return
    end
    MySQL.insert('INSERT INTO player_wagons(citizenid, name, wagon, active) VALUES(@citizenid, @name, @wagon, @active)', {
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@name'] = newnames,
        ['@wagon'] = model,
        ['@active'] = false,
    })
    Player.Functions.RemoveMoney('cash', price)
    print("You have successfully bought a wagon")
end)

RegisterServerEvent('tcrp-wagons:server:SetWagosActive', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local activewagon = MySQL.scalar.await('SELECT id FROM player_wagons WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, true})
    MySQL.update('UPDATE player_wagons SET active = ? WHERE id = ? AND citizenid = ?', { false, activewagon, Player.PlayerData.citizenid })
    MySQL.update('UPDATE player_wagons SET active = ? WHERE id = ? AND citizenid = ?', { true, id, Player.PlayerData.citizenid })
end)

RegisterServerEvent('tcrp-wagons:server:SetWagosUnActive', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    local activewagon = MySQL.scalar.await('SELECT id FROM player_wagons WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, false})
    MySQL.update('UPDATE player_wagons SET active = ? WHERE id = ? AND citizenid = ?', { false, activewagon, Player.PlayerData.citizenid })
    MySQL.update('UPDATE player_wagons SET active = ? WHERE id = ? AND citizenid = ?', { false, id, Player.PlayerData.citizenid })
end)

RegisterServerEvent('tcrp-wagons:server:DelWagos', function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
    MySQL.update('DELETE FROM player_wagons WHERE id = ? AND citizenid = ?', { id, Player.PlayerData.citizenid })
end)

QRCore.Functions.CreateCallback('tcrp-wagons:server:GetWagon', function(source, cb,comps)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local GetWagon = {}
	local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE citizenid=@citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid,
    })    
	if wagons[1] ~= nil then
        cb(wagons)
	end
end)

QRCore.Functions.CreateCallback('tcrp-wagons:server:GetActiveWagon', function(source, cb)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_wagons WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

RegisterNetEvent("tcrp-wagons:server:TradeWagon", function(playerId, wagonId, source, cb)
    local src = source
    local Player2 = QRCore.Functions.GetPlayer(playerId)
    local Playercid2 = Player2.PlayerData.citizenid
    local result = MySQL.update('UPDATE player_wagons SET citizenid = ?  WHERE citizenid = ? AND active = ?', {Playercid2, wagonId, 1})
    MySQL.update('UPDATE player_wagons SET active = ?  WHERE citizenid = ? AND active = ?', {0, Playercid2, 1})
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)
--[[ ------------------------------------- Wagon Customization  -------------------------------------

QRCore.Functions.CreateCallback('tcrp-wagons:server:CheckSaddle', function(source, cb)
	local src = source
	local encodedSaddle = json.encode(SaddleDataEncoded)
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT saddle FROM player_wagons WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-wagons:server:CheckBlanket', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT blanket FROM player_wagons WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-wagons:server:CheckHorn', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT horn FROM player_wagons WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

QRCore.Functions.CreateCallback('tcrp-wagons:server:CheckBag', function(source, cb)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT horn FROM player_wagons WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = Playercid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

RegisterNetEvent("tcrp-wagons:server:SaveSaddle", function(SaddleDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if SaddleDataEncoded ~= nil then
        MySQL.update('UPDATE player_wagons SET saddle = ?  WHERE citizenid = ? AND active = ?', {SaddleDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)


RegisterNetEvent("tcrp-wagons:server:SaveBlanket", function(BlanketDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if BlanketDataEncoded ~= nil then
        MySQL.update('UPDATE player_wagons SET blanket = ?  WHERE citizenid = ? AND active = ? ' , {BlanketDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-wagons:server:SaveHorn", function(HornDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if HornDataEncoded ~= nil then
        MySQL.update('UPDATE player_wagons SET horn = ?  WHERE citizenid = ? AND active = ?', {HornDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)

RegisterNetEvent("tcrp-wagons:server:SaveBag", function(BagDataEncoded)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    if BagDataEncoded ~= nil then
        MySQL.update('UPDATE player_wagons SET horn = ?  WHERE citizenid = ? AND active = ?', {BagDataEncoded ,  Player.PlayerData.citizenid, 1 })
    end
end)
 ]]